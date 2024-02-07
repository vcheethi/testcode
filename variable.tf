variable "storage_account_name" {

}

variable "resource_group_name" {

}

variable "location" {

}

variable "account_kind" {

}

variable "account_tier" {

}

variable "access_tier" {

}

variable "account_replication_type" {

}

variable "enable_https_traffic_only" {

}

variable "min_tls_version" {
  default = "TLS1_2"
}

#variable "allow_blob_public_access" {
#    default     = false
#}

variable "allow_nested_items_to_be_public" {
  default     = false
}

variable "nfsv3_enabled" {

}

variable "is_hns_enabled" {

}

variable "large_file_share_enabled" {

}

variable "tags" {

}

variable "default_action" {

}

variable "ip_rules" {

}

variable "virtual_network_subnet_ids" {}


variable "change_feed_enabled" {

}

variable "container_soft_delete_retention_days" {

}

variable "blob_soft_delete_retention_days" {

}

variable "blob_enable_versioning" {

}

variable "share_soft_delete_retention_days" {

}

variable "containers_list" {
  description = "List of containers to create and their access levels."
#  type        = list(object({ name = string, access_type = string }))
  default     = []
}

variable "file_shares" {
  description = "List of containers to create and their access levels."
#  type        = list(object({ name = string, quota = number }))
  default     = []
}

variable "queues" {
  description = "List of storages queues"
#  type        = list(string)
  default     = []
}

variable "tables" {
  description = "List of storage tables."
#  type        = list(string)
  default     = []
}

variable "blob_private_endpoint_required" {
  default     = false
}

variable "file_private_endpoint_required" {
  default     = false
}

variable "queue_private_endpoint_required" {
  default     = false
}

variable "table_private_endpoint_required" {
  default     = false
}

variable "dfs_private_endpoint_required" {
  default     = false
}

variable "privatendpoint_subnet_id"{

}

variable "network_rules_bypass" {

}

variable "network_routing" {
  
}

