# Output the Application Gateway public IP
output "application_gateway_public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = azurerm_public_ip.appgw.ip_address
}

# Output backend VM information
output "backend_vm_names" {
  description = "Names of the backend VMs"
  value       = azurerm_windows_virtual_machine.backend[*].name
}

output "backend_vm_private_ips" {
  description = "Private IP addresses of the backend VMs"
  value       = azurerm_network_interface.backend[*].private_ip_address
}

# Output resource group information
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}