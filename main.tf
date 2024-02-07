resource "azurerm_storage_account" "stgaccount" {
  name                      = var.storage_account_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  access_tier               = var.access_tier
  account_replication_type  = var.account_replication_type
  enable_https_traffic_only = var.enable_https_traffic_only
  min_tls_version           = var.min_tls_version
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  nfsv3_enabled             = var.nfsv3_enabled 
  is_hns_enabled            = var.is_hns_enabled
  large_file_share_enabled  = var.large_file_share_enabled
  tags                      = var.tags

  network_rules {
    default_action             = var.default_action
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
    bypass                     = ["${var.network_rules_bypass}"]
  }

  blob_properties {
    change_feed_enabled = var.change_feed_enabled
    container_delete_retention_policy {
      days = var.container_soft_delete_retention_days
    }
    delete_retention_policy {
      days = var.blob_soft_delete_retention_days
    }
    versioning_enabled = var.blob_enable_versioning
  }

  share_properties {
    retention_policy{
      days = var.share_soft_delete_retention_days
    }
  }

  routing{
    choice = var.network_routing
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [tags, large_file_share_enabled, blob_properties, network_rules[0].private_link_access]
  }
}


locals {
  container_resources    = var.containers_list
  fileshare_resources    = var.file_shares
}

resource "azurerm_storage_container" "container" {
  for_each              = local.container_resources

  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.stgaccount.name
  container_access_type = each.value.access_type


  lifecycle {
  #  prevent_destroy = true
    ignore_changes = []
  }
}

resource "azurerm_storage_share" "fileshare" {
 for_each              = local.fileshare_resources

 name                  = each.value.name
 storage_account_name  = azurerm_storage_account.stgaccount.name
 quota                 = each.value.quota

  lifecycle {
    prevent_destroy = true
    ignore_changes = []
  }
}

resource "azurerm_storage_table" "tables" {
  for_each              = toset(var.tables)

  name                  = each.key
  storage_account_name  = azurerm_storage_account.stgaccount.name

  lifecycle {
    prevent_destroy = true
    ignore_changes = []
  }
}

resource "azurerm_storage_queue" "queues" {
  for_each              = toset(var.queues)

  name                  = each.key
  storage_account_name  = azurerm_storage_account.stgaccount.name

  lifecycle {
    prevent_destroy = true
    ignore_changes = []
  }
}


###

resource "azurerm_private_endpoint" "blob" {
  count               = var.blob_private_endpoint_required ? 1 : 0
  name                = "pri_${var.storage_account_name}_blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.privatendpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "pri_${var.storage_account_name}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.stgaccount.id
    subresource_names              = ["blob"]
  }

  lifecycle {
    #prevent_destroy = true
    ignore_changes = [tags]
  }
}

resource "azurerm_private_endpoint" "file" {
  count               = var.file_private_endpoint_required ? 1 : 0
  name                = "pri_${var.storage_account_name}_file"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.privatendpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "pri_${var.storage_account_name}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.stgaccount.id
    subresource_names              = ["file"]
  }

  lifecycle {
    #prevent_destroy = true
    ignore_changes = [tags]
  }
}

resource "azurerm_private_endpoint" "queue" {
  count               = var.queue_private_endpoint_required ? 1 : 0
  name                = "pri_${var.storage_account_name}_queue"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.privatendpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "pri_${var.storage_account_name}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.stgaccount.id
    subresource_names              = ["queue"]
  }

  lifecycle {
    #prevent_destroy = true
    ignore_changes = [tags]
  }
}

resource "azurerm_private_endpoint" "table" {
  count               = var.table_private_endpoint_required ? 1 : 0
  name                = "pri_${var.storage_account_name}_table"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.privatendpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "pri_${var.storage_account_name}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.stgaccount.id
    subresource_names              = ["table"]
  }

  lifecycle {
    #prevent_destroy = true
    ignore_changes = [tags]
  }
}

resource "azurerm_private_endpoint" "dfs" {
  count               = var.dfs_private_endpoint_required ? 1 : 0
  name                = "pri_${var.storage_account_name}_dfs"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.privatendpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "pri_${var.storage_account_name}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.stgaccount.id
    subresource_names              = ["dfs"]
  }

  lifecycle {
    #prevent_destroy = true
    ignore_changes = [tags]
  }
}

resource "null_resource" "blob" {
 count                = var.blob_private_endpoint_required ? 1 : 0
 provisioner "local-exec" {
   command = "sleep 60; cd ../ANSIBLE-PLAYBOOK; ansible-playbook -i inventory -e 'hostname=${azurerm_storage_account.stgaccount.name} newprivateip=${azurerm_private_endpoint.blob[0].private_service_connection.0.private_ip_address} type=blob' dns_record_create.yaml --vault-password-file /terraform/myagent/.yono"
 }
}

resource "null_resource" "file" {
 count                = var.file_private_endpoint_required ? 1 : 0
 provisioner "local-exec" {
   command = "sleep 60; cd ../ANSIBLE-PLAYBOOK; ansible-playbook -i inventory -e 'hostname=${azurerm_storage_account.stgaccount.name} newprivateip=${azurerm_private_endpoint.file[0].private_service_connection.0.private_ip_address} type=file' dns_record_create.yaml --vault-password-file /terraform/myagent/.yono"
 }
}

resource "null_resource" "queue" {
 count                = var.queue_private_endpoint_required ? 1 : 0
 provisioner "local-exec" {
   command = "sleep 60; cd ../ANSIBLE-PLAYBOOK; ansible-playbook -i inventory -e 'hostname=${azurerm_storage_account.stgaccount.name} newprivateip=${azurerm_private_endpoint.queue[0].private_service_connection.0.private_ip_address} type=queue' dns_record_create.yaml --vault-password-file /terraform/myagent/.yono"
 }
}

resource "null_resource" "table" {
 count                = var.table_private_endpoint_required ? 1 : 0
 provisioner "local-exec" {
   command = "sleep 60; cd ../ANSIBLE-PLAYBOOK; ansible-playbook -i inventory -e 'hostname=${azurerm_storage_account.stgaccount.name} newprivateip=${azurerm_private_endpoint.table[0].private_service_connection.0.private_ip_address} type=table' dns_record_create.yaml --vault-password-file /terraform/myagent/.yono"
 }
}

resource "null_resource" "dfs" {
 count                = var.dfs_private_endpoint_required ? 1 : 0
 provisioner "local-exec" {
   command = "sleep 60; cd ../ANSIBLE-PLAYBOOK; ansible-playbook -i inventory -e 'hostname=${azurerm_storage_account.stgaccount.name} newprivateip=${azurerm_private_endpoint.dfs[0].private_service_connection.0.private_ip_address} type=dfs' dns_record_create.yaml --vault-password-file /terraform/myagent/.yono"
 }
}
