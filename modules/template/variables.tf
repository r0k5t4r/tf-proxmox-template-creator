variable "proxmox_node" {}

variable "sshuser" {}
variable "sshpass" {}
variable "ssh_private_key" {}

variable "image_url" {}
variable "image_filename" {}
variable "image_dir" {
  default = "/var/lib/vz/template/qcow2"
}

variable "template_name" {}
variable "template_vmid" {}

variable "storage" {}
variable "bridge" {}

variable "ci_user" {}
variable "ci_password" {
  sensitive = true
}
variable "ci_upgrade" {
  default = false
}

variable "nameserver" {}
variable "searchdomain" {}

variable "vendor_cloud_init_name" {
  description = "Vendor cloud-init file name (stored in modules/template/cloud-init)"
  type        = string
}

variable "default_cloud_init_name" {
  description = "Default cloud-init template filename"
  type        = string
  default     = "cloud-init-default.yaml.tpl"
}