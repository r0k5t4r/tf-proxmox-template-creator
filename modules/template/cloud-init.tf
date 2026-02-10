#
# Vendor cloud-init handling for Proxmox templates
#
# This renders a static vendor cloud-init file that is shipped
# with the module, injects a few variables, and uploads it to
# the Proxmox snippets directory.
#

locals {
  vendor_cloud_init = templatefile(
    "${path.module}/cloud-init/${var.vendor_cloud_init_name}",
    {
      ssh_key = file("${path.module}/ssh_keys.txt")
      user    = var.ci_user
    }
  )
}

resource "null_resource" "vendor_cloud_init" {
  triggers = {
    checksum = sha256(local.vendor_cloud_init)
  }

  connection {
    type        = "ssh"
    host        = var.proxmox_node
    user        = var.sshuser
    password    = var.sshpass
    #private_key = file(var.ssh_private_key)
  }

  provisioner "file" {
    content     = local.vendor_cloud_init
    destination = "/var/lib/vz/snippets/${var.vendor_cloud_init_name}"
  }
}
