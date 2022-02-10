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

locals {
  rule_default_prefix = "iq3"
  nsg_name            = "DefaultNSG"
}

resource "azurerm_network_security_group" "vnet_nsg" {
  name                = "${var.vnet_name}-${local.nsg_name}"
  location            = data.azurerm_resource_group.vnet_rg.location
  resource_group_name = data.azurerm_resource_group.vnet_rg.name

  tags = var.virtual_network_tags
}

# Common ASG's:

resource "azurerm_application_security_group" "quarantine" {
  name                = "${var.vnet_name}_Quarantine"
  location            = data.azurerm_resource_group.vnet_rg.location
  resource_group_name = data.azurerm_resource_group.vnet_rg.name

  tags = var.virtual_network_tags
}

resource "azurerm_application_security_group" "internet_out" {
  name                = "${var.vnet_name}_InternetOut"
  location            = data.azurerm_resource_group.vnet_rg.location
  resource_group_name = data.azurerm_resource_group.vnet_rg.name

  tags = var.virtual_network_tags
}

resource "azurerm_application_security_group" "linux_customer_access" {
  name                = "${var.vnet_name}_LinuxCustomerAccess"
  location            = data.azurerm_resource_group.vnet_rg.location
  resource_group_name = data.azurerm_resource_group.vnet_rg.name

  tags = var.virtual_network_tags
}

resource "azurerm_application_security_group" "on_prem_out" {
  name                = "${var.vnet_name}_OnPremOut"
  location            = data.azurerm_resource_group.vnet_rg.location
  resource_group_name = data.azurerm_resource_group.vnet_rg.name

  tags = var.virtual_network_tags
}

resource "azurerm_application_security_group" "sql_server" {
  name                = "${var.vnet_name}_Sqlserver"
  location            = data.azurerm_resource_group.vnet_rg.location
  resource_group_name = data.azurerm_resource_group.vnet_rg.name

  tags = var.virtual_network_tags
}

resource "azurerm_application_security_group" "web_server" {
  name                = "${var.vnet_name}_Webserver"
  location            = data.azurerm_resource_group.vnet_rg.location
  resource_group_name = data.azurerm_resource_group.vnet_rg.name

  tags = var.virtual_network_tags
}

resource "azurerm_application_security_group" "windows_customer_access" {
  name                = "${var.vnet_name}_WindowsCustomerAccess"
  location            = data.azurerm_resource_group.vnet_rg.location
  resource_group_name = data.azurerm_resource_group.vnet_rg.name

  tags = var.virtual_network_tags
}


# Common NSG Rules:

resource "azurerm_network_security_rule" "ssh_rdp_in_management" {
  name                        = "SshRdpIn_Management"
  priority                    = 400
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["22", "3389"]
  source_address_prefix       = var.iq3_management_ip_range
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = data.azurerm_resource_group.vnet_rg.name
  network_security_group_name = azurerm_network_security_group.vnet_nsg.name
}

resource "azurerm_network_security_rule" "quarantine_inbound_new_zone" {
  name                                       = "Quarantine_Inbound_newZone"
  priority                                   = 403
  direction                                  = "Inbound"
  access                                     = "Deny"
  protocol                                   = "*"
  source_port_range                          = "*"
  destination_port_range                     = "*"
  source_address_prefix                      = "*"
  destination_application_security_group_ids = [azurerm_application_security_group.quarantine.id]
  resource_group_name                        = data.azurerm_resource_group.vnet_rg.name
  network_security_group_name                = azurerm_network_security_group.vnet_nsg.name
}

resource "azurerm_network_security_rule" "ssh_in_customer_new_zone" {
  name                                       = "SshIn_Customer_newZone"
  priority                                   = 422
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "*"
  source_port_range                          = "*"
  destination_port_range                     = "22"
  source_address_prefix                      = "VirtualNetwork"
  resource_group_name                        = data.azurerm_resource_group.vnet_rg.name
  network_security_group_name                = azurerm_network_security_group.vnet_nsg.name
  destination_application_security_group_ids = [azurerm_application_security_group.linux_customer_access.id]
}

resource "azurerm_network_security_rule" "rdp_in_customer_new_zone" {
  name                                       = "RdpIn_Customer_newZone"
  priority                                   = 432
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "*"
  source_port_range                          = "*"
  destination_port_range                     = "3389"
  source_address_prefix                      = "VirtualNetwork"
  resource_group_name                        = data.azurerm_resource_group.vnet_rg.name
  network_security_group_name                = azurerm_network_security_group.vnet_nsg.name
  destination_application_security_group_ids = [azurerm_application_security_group.windows_customer_access.id]
}

resource "azurerm_network_security_rule" "http_https_port_in_new_zone" {
  name                                       = "Http_Https_Port_In_newZone"
  priority                                   = 2012
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "*"
  source_port_range                          = "*"
  destination_port_ranges                    = ["80", "443"]
  source_address_prefix                      = "*"
  resource_group_name                        = data.azurerm_resource_group.vnet_rg.name
  network_security_group_name                = azurerm_network_security_group.vnet_nsg.name
  destination_application_security_group_ids = [azurerm_application_security_group.web_server.id]
}

resource "azurerm_network_security_rule" "mssql_port_in_new_zone" {
  name                                       = "MsSql_Port_In_newZone"
  priority                                   = 2022
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "*"
  source_port_range                          = "*"
  destination_port_range                     = "1433"
  source_address_prefix                      = "VirtualNetwork"
  resource_group_name                        = data.azurerm_resource_group.vnet_rg.name
  network_security_group_name                = azurerm_network_security_group.vnet_nsg.name
  destination_application_security_group_ids = [azurerm_application_security_group.sql_server.id]
}

resource "azurerm_network_security_rule" "allow_icmp_in" {
  name                        = "Allow_ICMP_IN"
  priority                    = 4095
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "ICMP"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.vnet_rg.name
  network_security_group_name = azurerm_network_security_group.vnet_nsg.name
}

resource "azurerm_network_security_rule" "allow_icmp" {
  name                        = "Allow_ICMP"
  priority                    = 4095
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "ICMP"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.vnet_rg.name
  network_security_group_name = azurerm_network_security_group.vnet_nsg.name
}

resource "azurerm_network_security_rule" "deny_all_in" {
  name                        = "DenyAllIn"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.vnet_rg.name
  network_security_group_name = azurerm_network_security_group.vnet_nsg.name
}

resource "azurerm_network_security_rule" "quarantine_outbound_new_zone" {
  name                                  = "Quarantine_Outbound_newZone"
  priority                              = 403
  direction                             = "Outbound"
  access                                = "Deny"
  protocol                              = "*"
  source_port_range                     = "*"
  destination_port_range                = "*"
  destination_address_prefix            = "*"
  resource_group_name                   = data.azurerm_resource_group.vnet_rg.name
  source_application_security_group_ids = [azurerm_application_security_group.quarantine.id]
  network_security_group_name           = azurerm_network_security_group.vnet_nsg.name
}

resource "azurerm_network_security_rule" "internet_outbound_new_zone" {
  name                                  = "Internet_Outbound_newZone"
  priority                              = 413
  direction                             = "Outbound"
  access                                = "Allow"
  protocol                              = "*"
  source_port_range                     = "*"
  destination_port_range                = "*"
  destination_address_prefix            = "Internet"
  resource_group_name                   = data.azurerm_resource_group.vnet_rg.name
  source_application_security_group_ids = [azurerm_application_security_group.internet_out.id]
  network_security_group_name           = azurerm_network_security_group.vnet_nsg.name
}

resource "azurerm_network_security_rule" "on_prem_outbound_new_zone" {
  name                                  = "OnPrem_Outbound_NewZone"
  priority                              = 414
  direction                             = "Outbound"
  access                                = "Allow"
  protocol                              = "*"
  source_port_range                     = "*"
  destination_port_range                = "*"
  destination_address_prefix            = "VirtualNetwork"
  resource_group_name                   = data.azurerm_resource_group.vnet_rg.name
  source_application_security_group_ids = [azurerm_application_security_group.on_prem_out.id]
  network_security_group_name           = azurerm_network_security_group.vnet_nsg.name
}

resource "azurerm_network_security_rule" "azure_services_outbound" {
  name                        = "AzureServices_Outbound"
  priority                    = 420
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  destination_address_prefix  = "AzureCloud"
  source_address_prefix       = "VirtualNetwork"
  resource_group_name         = data.azurerm_resource_group.vnet_rg.name
  network_security_group_name = azurerm_network_security_group.vnet_nsg.name
}

resource "azurerm_network_security_rule" "deny_all_out" {
  name                        = "DenyAllOut"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "DENY"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  destination_address_prefix  = "*"
  source_address_prefix       = "*"
  resource_group_name         = data.azurerm_resource_group.vnet_rg.name
  network_security_group_name = azurerm_network_security_group.vnet_nsg.name
}

# virtual network

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_ip_range]
  location            = data.azurerm_resource_group.vnet_rg.location
  resource_group_name = data.azurerm_resource_group.vnet_rg.name
  dns_servers         = length(var.dns_servers) == 0 ? [] : concat(var.dns_servers, ["168.63.129.16"])

  tags = var.virtual_network_tags
}

resource "azurerm_subnet" "subnet" {
  name                                           = each.key
  resource_group_name                            = data.azurerm_resource_group.vnet_rg.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = [each.value.ip_range]
  service_endpoints                              = try(each.value.service_endpoints, null) == null ? null : [each.value.service_endpoints]
  enforce_private_link_endpoint_network_policies = each.value.apply_service_endpoint_policies
  for_each                                       = var.vnet_subnet_ranges
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.vnet_nsg.id

  for_each = {
    for key, value in var.vnet_subnet_ranges :
    key => value
    if value.attach_nsg != false
  }
}

resource "azurerm_subnet_route_table_association" "rt_association" {
  subnet_id      = azurerm_subnet.subnet[each.key].id
  route_table_id = var.routetable_resource_id
  for_each = {
    for key, value in var.vnet_subnet_ranges :
    key => value
    if var.routetable_resource_id != ""
  }
}