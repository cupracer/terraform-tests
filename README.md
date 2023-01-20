# terraform-tests

## Prepare project directory:
```shell
mkdir <project_dir>
cd <project_dir>
git clone https://github.com/cupracer/terraform-tests.git modules
```

## Add config file (e.g. for local hypervisor):
```shell
terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri   = "qemu:///system"
}


module "opensuse_leap_example2" {
  source = "./modules/opensuse_leap_example2"
  hostname = "tfexample1"
  dns_domain = "example.com"
  network_bridge = "br0"
  timezone = "Europe/Berlin"
}
```

## Run Terraform
```shell
terraform init
terraform plan
terraform apply
```

