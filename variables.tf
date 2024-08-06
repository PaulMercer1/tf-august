variable "web_vm_size" {
  type = string
  description = "Enter the Azure size for the web vm"
  
  default = "Standard_D2"
}

# Disk space in GB for the web server
variable "web_disk_size" {
  type = number
  default = 30
}

variable "address_space" {
  type = list(string)
  default = ["10.0.0.0/16"]
}

variable vm_count {
    type = number
    default = 4
}