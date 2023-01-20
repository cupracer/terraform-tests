###########################################################
# PROVIDERS
###########################################################

terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}


###########################################################
# LOCALS
###########################################################

locals {
}


###########################################################
# VOLUMES
###########################################################

resource "libvirt_volume" "base_image" {
  name   = "${var.hostname}_base.qcow2"
  pool   = "default"
  source = "https://download.opensuse.org/distribution/leap/15.4/appliances/openSUSE-Leap-15.4-JeOS.x86_64-OpenStack-Cloud.qcow2"
  format = "qcow2"
}

resource "libvirt_volume" "system_volume" {
  name           = "${var.hostname}_system.qcow2"
  base_volume_id = libvirt_volume.base_image.id
  size           = var.disk_size
}


###########################################################
# CLOUD-INIT
###########################################################

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field

resource "libvirt_cloudinit_disk" "cloud_init" {
  name           = "${var.hostname}_cloud_init.iso"
  user_data      = templatefile("${path.module}/cloud_init_user_data.tftpl", {
    hostname = var.hostname
    root_password = var.root_password
    authorized_keys = try(split("\n",file(var.authorized_keys_file)), null)
  })
  network_config = templatefile("${path.module}/cloud_init_network_config.tftpl", {
    hostname = var.hostname
  })
}


###########################################################
# LIBVIRT DOMAINS
###########################################################

resource "libvirt_domain" "system" {
  name   = var.hostname
  memory = var.memory
  vcpu   = var.vcpu

  network_interface {
    bridge = var.network_bridge
    wait_for_lease = true
  }

  cloudinit = libvirt_cloudinit_disk.cloud_init.id

  qemu_agent = true

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.system_volume.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = libvirt_domain.system.network_interface[0].addresses[0]
  }

  provisioner "file" {
    source      = "${path.module}/salt"
    destination = "/srv/salt"
  }

  provisioner "remote-exec" {
    inline = [
      "salt-call --local state.apply",
    ]
  }
}


###########################################################
# OUTPUT
###########################################################

output "ip" {
  value = libvirt_domain.system.network_interface[0].addresses[0]
}

