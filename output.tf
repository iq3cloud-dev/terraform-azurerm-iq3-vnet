# A Terraform module to create a subset of cloud components
# Copyright (C) 2022 IQ3 CLOUD Skaylink GmbH

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version. 

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# For questions and contributions please contact info@iq3cloud.com
# https://github.com/iq3cloud-dev/terraform-azurerm-iq3-vnet

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

output "asg_quarantine" {
  value = azurerm_application_security_group.quarantine
}

output "asg_internet_out" {
  value = azurerm_application_security_group.internet_out
}

output "asg_linux_customer_access" {
  value = azurerm_application_security_group.linux_customer_access
}

output "asg_on_prem_out" {
  value = azurerm_application_security_group.on_prem_out
}

output "asg_sql_server" {
  value = azurerm_application_security_group.sql_server
}

output "asg_web_server" {
  value = azurerm_application_security_group.web_server
}

output "asg_windows_customer_access" {
  value = azurerm_application_security_group.windows_customer_access
}