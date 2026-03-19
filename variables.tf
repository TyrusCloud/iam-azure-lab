
# VM admin credentials
variable "vm_admin_username" {
  description = "Admin username for Windows VM"
  type        = string
  default     = "azureadmin"
}

variable "vm_admin_password" {
  description = "Admin password for Windows VM"
  type        = string
  sensitive   = true
}

# VM size
variable "vm_size" {
  description = "Size of the Windows VM"
  type        = string
  default     = "Standard_D2s_v4"
}
