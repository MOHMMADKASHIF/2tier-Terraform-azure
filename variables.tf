variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-2tier-app"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vm_count" {
  description = "Number of backend VMs"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "Size of the backend VMs"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  description = "Admin password for VMs"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "2-Tier-App"
    ManagedBy   = "Terraform"
  }
}