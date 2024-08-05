terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.114.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}
resource "azurerm_resource_group" "example" {
  name     = "RG2"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "lab2-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "lab2-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}



resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lab2publicpip.id
  }
}

resource "azurerm_public_ip" "lab2publicpip" {
  name                    = "lab2-pip"
  location                = azurerm_resource_group.lab2.location
  resource_group_name     = azurerm_resource_group.lab2.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    Lab_edit  = "ThirdChange"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "VM1"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B2s"
  
  admin_username      = "adminuser"
  admin_password = "Pa$$w0rd1234"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    environment = "training"
    department = "cloud"
    region = azurerm_resource_group.example.location
  }
}