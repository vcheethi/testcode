data "azurerm_storage_account" "stgaccount" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

/*
resource "azurerm_function_app" "function" {
  name                       = var.function_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  app_service_plan_id        = var.app_service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = data.azurerm_storage_account.stgaccount.primary_access_key
  https_only                 = true
  os_type                    = "linux"
  version                    = "~3"
  app_settings               = var.app_settings
  tags                       = var.tags
}
*/

resource "azurerm_linux_function_app" "function" {
  name                       = var.function_name
  resource_group_name        = var.resource_group_name
  location                   = var.location

  storage_account_name       = var.storage_account_name
  storage_account_access_key = data.azurerm_storage_account.stgaccount.primary_access_key
  service_plan_id            = var.service_plan_id

  site_config {}
  app_settings               = var.app_settings
  tags                       = var.tags

  lifecycle {
    prevent_destroy = true
    ignore_changes = all
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  count               = var.vnet_integration_required ? 1 : 0

  app_service_id = azurerm_linux_function_app.function.id
  subnet_id      = var.subnet_id_for_vnet_integration
}


