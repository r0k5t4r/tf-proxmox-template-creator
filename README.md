# Terraform Proxmox Template Creator

A Terraform-based automation tool for creating Proxmox VM templates from cloud images (Ubuntu 20.04, 22.04, 24.04).

## Overview

This project automates the process of creating reusable Proxmox VM templates by:
1. Downloading cloud images from Ubuntu repositories
2. Converting and uploading images to Proxmox storage
3. Creating VM templates with cloud-init support
4. Configuring templates with vendor-specific cloud-init data

## Project Structure

```
.
├── main.tf                 # Root module configuration
├── variables.tf            # Variable definitions
├── outputs.tf              # Output definitions
├── provider.tf             # Proxmox provider configuration
├── terraform.tfvars        # Environment-specific values
├── modules/
│   └── template/           # Template creation module
│       ├── template.tf     # VM template resource
│       ├── image.tf        # Image download & conversion
│       ├── cloud-init.tf   # Cloud-init configuration
│       ├── variables.tf    # Module variables
│       └── cloud-init/     # Cloud-init templates
│           ├── default-cloud-init.yaml
│           └── ubuntu2404-vendor.yaml
├── images/                 # Image configuration files
│   ├── ubuntu_2004.tfvars
│   ├── ubuntu_2204.tfvars
│   └── ubuntu_2404.tfvars
└── .terraform/             # Terraform state (git-ignored)
```

## Prerequisites

- Terraform >= 0.13
- Proxmox VE 8.x or 9.x
- SSH access to Proxmox host for image/snippet uploads
- Telmate Proxmox provider (automatically downloaded)

## Configuration

### Setup Steps

1. **Configure Proxmox API credentials** in `terraform.tfvars`:
   ```hcl
   proxmox_api_url          = "https://your-pve-ip:8006/api2/json"
   proxmox_api_token_id     = "root@pam!terraform"
   proxmox_api_token_secret = "your-api-token"
   proxmox_node             = "pve"
   ```

2. **Set SSH credentials** for Proxmox host:
   ```hcl
   sshuser = "root"
   sshpass = "your-password"
   ```

3. **Select template image** using environment-specific tfvars:
   ```bash
   # For Ubuntu 22.04
   terraform plan -var-file="images/ubuntu_2204.tfvars"
   ```

### Key Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `image_url` | Cloud image download URL | `https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img` |
| `template_name` | Proxmox template display name | `ubuntu-22.04-template` |
| `template_vmid` | Unique VM ID for template | `3001` |
| `storage` | Proxmox storage location | `local-lvm` |
| `bridge` | Network bridge for VM | `vmbr0` |
| `nameserver` | DNS server for cloud-init | `8.8.8.8` |

## Usage

### Create Template

Initialize (required once):
```bash
tofu init
```

Plan template creation:
```bash
# Ubuntu 22.04
tofu plan \
  -var-file=images/ubuntu_2204.tfvars \
  -state=ubuntu_2204.tfstate \
  --lock=false

# Ubuntu 24.04
tofu plan \
  -var-file=images/ubuntu_2404.tfvars \
  -state=ubuntu_2404.tfstate \
  --lock=false
```

Apply to create template:
```bash
# Ubuntu 22.04
tofu apply \
  -var-file=images/ubuntu_2204.tfvars \
  -state=ubuntu_2204.tfstate \
  --lock=false

# Ubuntu 24.04
tofu apply \
  -var-file=images/ubuntu_2404.tfvars \
  -state=ubuntu_2404.tfstate \
  --lock=false
```

**Note:** This project uses OpenTofu (`tofu`), but standard Terraform (`terraform`) commands work identically.

### Manage Multiple Images

Environment-specific tfvars files (in `images/`) define:
- Image URL and filename
- Template name and VMID
- Cloud-init configuration

Each Ubuntu version has its own state file to maintain independent templates.

### Destroy Template

```bash
tofu destroy \
  -var-file=images/ubuntu_2204.tfvars \
  -state=ubuntu_2204.tfstate \
  --lock=false
```

## Module Details

### Template Module (`modules/template/`)

Handles the complete template creation workflow:

- **image.tf**: Downloads cloud image and uploads to Proxmox storage
- **template.tf**: Creates VM template with 30GB disk, 4GB RAM, 2 CPU cores
- **cloud-init.tf**: Configures cloud-init for template provisioning

### Cloud-Init Configuration

- **default-cloud-init.yaml**: Base configuration for all templates
- **ubuntu2404-vendor.yaml**: Ubuntu 24.04-specific vendor data

Templates support standard cloud-init datasources (NoCloud) for VM initialization.

## Troubleshooting

### Common Issues

1. **Image download fails**: Verify Ubuntu image URL is correct and accessible
2. **SSH upload fails**: Ensure Proxmox credentials are correct and SSH port is accessible
3. **Provider version conflicts**: Adjust provider version in `provider.tf` (v3.0.1-rc8 for PVE 8.x, v3.0.2-rc07 for PVE 9.x)

### Debug Output

Enable Proxmox API debug logging:
```hcl
proxmox_debug = true
```

## Security Notes

- Store sensitive credentials in `.tfvars` files outside version control
- Use API tokens instead of passwords when possible
- Set `proxmox_tls_insecure = false` in production
- Rotate API tokens regularly

## Related Projects

- `tf-proxmox-multi-vms`: Deploy VMs from templates
- `tf-proxmox-multi-vms-priv`: Private deployment variant

## License

This project is part of the Proxmox Infrastructure as Code collection.
