variable "hostname" {
  type     = string
  nullable = false
}

variable "disk_size" {
  type     = number
  nullable = false
  default  = 32212254720
}

variable "vcpu" {
  type     = number
  default  = 2
}

variable "memory" {
  type     = number
  default  = 2048
}

variable "dns_domain" {
  type     = string
  nullable = false
}

variable "network_bridge" {
  type     = string
  nullable = false
}

variable "authorized_keys_file" {
  type     = string
  nullable = true
  default  = null
}

variable "root_password" {
  type     = string
  default  = "linux"
}

