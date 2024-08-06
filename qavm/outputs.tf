output "vm_ip" {
    sensitive = true
    value = azurerm_public_ip.public_ip.ip_address
}
