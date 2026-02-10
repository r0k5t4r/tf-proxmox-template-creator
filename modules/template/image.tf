resource "null_resource" "image" {
  provisioner "remote-exec" {
    inline = [
      "set -e",
      "mkdir -p ${var.image_dir}",
      "cd ${var.image_dir}",
      "if [ ! -f ${var.image_filename} ]; then wget -O ${var.image_filename} ${var.image_url}; fi",
      "command -v virt-customize || (apt-get update -y && apt-get install -y libguestfs-tools dhcpcd-base)",

<<-EOF
export LIBGUESTFS_BACKEND=direct
virt-customize --network -a ${var.image_filename} \
  --update \
  --install qemu-guest-agent \
  --root-password password:Password123 \
  --run-command 'echo -n > /etc/machine-id'
EOF

    ]

    connection {
      type         = "ssh"
      host         = var.proxmox_node
      user         = var.sshuser
      password     = var.sshpass
      #private_key  = file(var.ssh_private_key)
    }
  }
}
