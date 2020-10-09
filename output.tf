output "vnet" {
  value = azurerm_virtual_network.vnet
}

output "nsg" {
  value = azurerm_network_security_group.vnet_nsg
}

output "subnets" {
  value = azurerm_subnet.subnet

  depends_on = [
    azurerm_subnet_route_table_association.rt_association,
  ]
}