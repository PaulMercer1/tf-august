
terraform {
  required_providers {
      azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.114.0"
    }
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = local.standard_tags
}

resource "azurerm_public_ip" "public_ip" {
  name                    = local.pipname
  location                = var.location
  resource_group_name     = var.resource_group_name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = local.standard_tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = local.vm_size  #var.vm_size
  
  admin_username      = "adminuser"
  admin_password = "Pa$$w0rd1234"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.disk_size
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = local.standard_tags
}

locals {
  pipname = "${var.vm_name}-pip"
  
vm_size = terraform.workspace == "dev" ? "Standard_B2s" : "Standard_D2"

  standard_tags = {
    env = "prod"
    dept = "sales"
  }
}