variable "location" {
  description = "Name of the location where the resources will be provisioned"
  type = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type = string
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type = string
}


variable "service_plan_id" {
    type        = string
}



variable "function_name" {
  description = "Name of the function"
  type = string
}

variable "app_settings" {
    #
}

variable "vnet_integration_required" {
    type        = bool
}

variable "subnet_id_for_vnet_integration" {
    type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}


