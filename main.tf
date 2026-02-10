module "template" {
  source = "./modules/template"

  proxmox_node = var.proxmox_node

  sshuser         = var.sshuser
  sshpass         = var.sshpass
  ssh_private_key = var.ssh_private_key

  image_url      = var.image_url
  image_filename = var.image_filename
  image_dir      = var.image_dir

  template_name = var.template_name
  template_vmid = var.template_vmid

  storage = var.storage
  bridge  = var.bridge

  ci_user     = var.ci_user
  ci_password = var.ci_password
  ci_upgrade  = var.ci_upgrade

  nameserver   = var.nameserver
  searchdomain = var.searchdomain

  vendor_cloud_init_name = var.vendor_cloud_init_name

}
