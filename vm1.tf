module "vm1" {
  source = "./qavm"
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location
  subnet_id = azurerm_subnet.example.id
  vm_name = "VM1"
}
