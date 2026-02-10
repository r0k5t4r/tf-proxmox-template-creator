# Provider configuration
terraform {
  required_version = ">= 0.13"
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      # use the old provider version for PVE version 8.x if the newer version causes issues
      #version = "3.0.1-rc8"
      # use the new provider version for PVE version 9.x
      version = "3.0.2-rc07"
    }
  }
}

# Configure the Proxmox provider
provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = var.proxmox_tls_insecure # Set to false in production
  pm_debug            = var.proxmox_debug
}