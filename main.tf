data "azurerm_virtual_network" "main" {
  name                = var.dbw_vnet
  resource_group_name = var.dbw_vnet_rg
}

resource "azurerm_subnet" "public_subnet" {
  name                 = "snet_${var.dbw_name}_pub"
  resource_group_name  = var.dbw_vnet_rg
  virtual_network_name = var.dbw_vnet
  address_prefixes     = var.dbw_subnet_pub_prefix
  service_endpoints    = var.pub_service_endpoints

  delegation {
    name = "snet_${var.dbw_name}_pub_delegatoin"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
      name = "Microsoft.Databricks/workspaces"
    }
  }
}

resource "azurerm_subnet" "private_subnet" {
  name                 = "snet_${var.dbw_name}_pri"
  resource_group_name  = var.dbw_vnet_rg
  virtual_network_name = var.dbw_vnet
  address_prefixes     = var.dbw_subnet_pri_prefix
  service_endpoints    = var.pri_service_endpoints

  delegation {
    name = "snet_${var.dbw_name}_pri_delegatoin"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
      name = "Microsoft.Databricks/workspaces"

    }

  }
}

resource "azurerm_network_security_group" "databricks_subnet_nsg" {
  name                = "nsg_snet_${var.dbw_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "nsg_asso_pub" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.databricks_subnet_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_asso_pri" {
  subnet_id                 = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.databricks_subnet_nsg.id
}


resource "azurerm_databricks_workspace" "databricks" {
  name                                = var.dbw_name
  resource_group_name                 = var.resource_group_name
  location                            = var.location
  sku                                 = var.dbw_sku
  infrastructure_encryption_enabled   = var.dbw_infrastructure_encryption_enabled
  tags                                = var.tags
  custom_parameters {
    virtual_network_id                                   = data.azurerm_virtual_network.main.id
    public_subnet_name                                   = "snet_${var.dbw_name}_pub"
    private_subnet_name                                  = "snet_${var.dbw_name}_pri"
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.nsg_asso_pub.id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.nsg_asso_pri.id
  }
  
  lifecycle {
    prevent_destroy = true
    ignore_changes  = []
    }
}