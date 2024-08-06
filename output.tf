output "vm1_ip" {
    sensitive = true
    value = azurerm_public_ip.lab2publicpip.ip_address
}