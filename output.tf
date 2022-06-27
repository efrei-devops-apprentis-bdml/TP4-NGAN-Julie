output "public_ip_address" {
  value = azurerm_linux_virtual_machine.devops-20180476.public_ip_address
}

output "tls_private_key" {
  value     = tls_private_key.ssh_20180476.private_key_pem 
  sensitive = true
}