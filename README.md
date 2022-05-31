# Deprecation notice

As of 01.06.2022 this module has been superseded by the new and improved Skaylink version, all future updates will be applied to the new version, which can be found [here](https://registry.terraform.io/modules/skaylink/skaylink-vnet/azurerm/latest)

## terraform-azurerm-iq3-vnet

This template is part of the IQ3 CLOUD component collection.

### Example of Variable `vnet_subnet_range`
```terraform
vnet_subnet_range = {
  "backend-subnet" = {
    "ip_range"                        = "10.10.10.0/24"
    "attach_nsg"                      = true
    "service_endpoints"               = null
    "apply_service_endpoint_policies" = true
    "apply_service_link_policies"     = false
    "service_delegation"              = null
    "service_delegation_actions"      = []
  }
  "databricks-host-subnet" = {
    "ip_range"                        = "10.10.11.0/24"
    "attach_nsg"                      = true
    "service_endpoints"               = null
    "apply_service_endpoint_policies" = false
    "apply_service_link_policies"     = false
    "service_delegation"              = "Microsoft.Databricks/workspaces",
    "service_delegation_actions"      = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action", ]
  }
}
```