output "vm_private_ip" {
  value = azurerm_network_interface.nic.private_ip_address
}

output "vm_name" {
  value = azurerm_windows_virtual_machine.dc.name
}

output "bastion_ip" {
  value = azurerm_public_ip.bastion_ip.ip_address
}
