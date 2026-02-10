output "template_info" {
  description = "Proxmox template details"
  value = {
    name    = var.template_name
    vmid    = var.template_vmid
    node    = var.proxmox_node
    storage = var.storage
  }
}

output "image_info" {
  description = "Base image used for the template"
  value = {
    image_url      = var.image_url
    image_filename = var.image_filename
    image_dir      = var.image_dir
  }
}

output "clone_example" {
  description = "Example qm command to clone from this template"
  value       = "qm clone ${var.template_vmid} 100 --name test-vm --full true"
}

output "cloud_init_defaults" {
  description = "Cloud-init defaults configured in the template"
  value = {
    user    = var.ci_user
    upgrade = var.ci_upgrade
    dns     = var.nameserver
    domain  = var.searchdomain
  }
}

output "template_reference" {
  description = "Values to reference this template from another OpenTofu project"
  value = {
    template_name = var.template_name
    template_vmid = var.template_vmid
    node          = var.proxmox_node
  }
}
