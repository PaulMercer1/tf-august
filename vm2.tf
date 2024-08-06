
# comments

resource "azurerm_network_interface" "example2" {
  name                = "example2-nic-${count.index}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  count = var.vm_count
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lab2publicpip2[count.index].id
  }
}

resource "azurerm_public_ip" "lab2publicpip2" {
  name                    = "lab2-pip2-${count.index}"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
  count = var.vm_count
  tags = {
    Lab_edit  = "ThirdChange"
  }
}

resource "azurerm_linux_virtual_machine" "example2" {
  name                = "VM2-${count.index}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.web_vm_size
  
  count = var.vm_count

  admin_username      = "adminuser"
  admin_password = "Pa$$w0rd1234"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.example2[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.web_disk_size
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
    region = "Built in ${azurerm_resource_group.example.location}"
  }
}