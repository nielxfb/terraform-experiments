variable "subscription_id" {
  description = "The Subscription ID for the Azure Subscription"
  type        = string
}

variable "username" {
  description = "The admin username for the VM"
  type        = string
  default     = "adminuser"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_port" {
  description = "The SSH port for the VM"
  type        = number
  default     = 22
}
