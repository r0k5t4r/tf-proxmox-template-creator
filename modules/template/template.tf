resource "proxmox_vm_qemu" "template" {
  depends_on = [
    null_resource.image,
    null_resource.vendor_cloud_init
  ]

  name        = var.template_name
  vmid        = var.template_vmid
  target_node = var.proxmox_node

  os_type  = "cloud-init"
  agent    = 1

  network {
      id     = 0
      model  = "virtio"
      bridge = "vmbr0"
    }

  cpu {
    cores    = 2
    sockets  = 1
    type     = "host"
  }
   memory   = 4096

  disk {
    slot    = "virtio0"
    type    = "disk"
    storage = var.storage
    size    = "30G"
  }

  disk {
    slot    = "scsi1"
    type    = "cloudinit"
    storage = var.storage
  }

  # 👇 vendor cloud-init

  ciuser     = var.ci_user
  cipassword = var.ci_password

  ipconfig0 = "ip=dhcp"
}

resource "null_resource" "convert_to_template" {
  depends_on = [proxmox_vm_qemu.template]

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "qm stop ${var.template_vmid} || true",
      "qm template ${var.template_vmid}"
    ]

    connection {
      type        = "ssh"
      host        = var.proxmox_node
      user        = var.sshuser
      password    = var.sshpass
      #private_key = file(var.ssh_private_key)
    }
  }
}
