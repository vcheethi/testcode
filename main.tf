resource "azurerm_linux_web_app" "app_service_linux" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id
  https_only          = var.https_only
  enabled             = var.enabled
  
  tags                = var.tags

  identity {
    identity_ids      = var.identity_ids
    type              = var.identity_type
  }

  app_settings = var.app_settings

  site_config {
    minimum_tls_version = var.minimum_tls_version
       
    application_stack {
      docker_image        = var.docker_image
      docker_image_tag    = var.docker_image_tag
      dotnet_version      = var.dotnet_version
      java_server         = var.java_server
      java_server_version = var.java_server_version
      java_version        = var.java_version
      node_version        = var.node_version
      php_version         = var.php_version
      python_version      = var.python_version
      ruby_version        = var.ruby_version
    }
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = all
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  count               = var.vnet_integration_required ? 1 : 0

  app_service_id = azurerm_linux_web_app.app_service_linux.id
  subnet_id      = var.subnet_id_for_vnet_integration
}
