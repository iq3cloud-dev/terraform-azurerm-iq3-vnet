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
  type        = map
  description = "A map of subnet names and their ranges (key: Subnet Name, Value: Subnet Range)"
}

variable "routetable_resource_id" {
  type        = string
  default     = ""
  description = "Resource Id of the route table to be attached to the subnets"
}