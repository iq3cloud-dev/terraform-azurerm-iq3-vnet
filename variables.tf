# A Terraform module to create a subset of cloud components
# Copyright (C) 2020 IQ3 CLOUD Solutions Direkt GmbH

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

variable "vnet_name" {
  type        = string
  description = "The name of the virtual network"
}

variable "iq3_management_ip_range" {
  type        = string
  description = "The IP range of the IQ3 management virtual network"
}

variable "vnet_ip_range" {
  type        = string
  description = "The IP range of the whole Virtual Network"
}

variable "vnet_resourcegroup" {
  type        = string
  description = "The resource group where the virtual network and network security group will be located in"
}

variable "dns_servers" {
  type        = list(string)
  description = "DNS servers to be configured for the virtual network (will be added along with the Azure Magic IP)"
}

variable "vnet_subnet_ranges" {
  type        = map(any)
  description = "A map of subnet names and their ranges (key: Subnet Name, Value: Subnet Range)"
}

variable "routetable_resource_id" {
  type        = string
  default     = ""
  description = "Resource Id of the route table to be attached to the subnets"
}