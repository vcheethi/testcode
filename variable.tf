variable "app_service_name" {
    type        = string
}

variable "location" {
    type        = string
}

variable "resource_group_name" {
    type        = string
}

variable "service_plan_id" {
    type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vnet_integration_required" {
    type        = bool
}

variable "subnet_id_for_vnet_integration" {
    type        = string
}

variable "minimum_tls_version" {
    default     = "1.2"
}

variable "https_only" {
    type       = bool
    default    = true
}

variable "enabled" {
    default    = true
}

variable "identity_ids" {
    default = null
}

variable "identity_type" {
    type     = string
}

variable "docker_image" {
    default     = null
}

variable "docker_image_tag" {
    default     = null
}

variable "dotnet_version" {
    default     = null
}

variable "java_server" {
    default     = null
}

variable "java_server_version" {
    default     = null
}

variable "java_version" {
    default     = null
}

variable "node_version" {
    default     = null
}

variable "php_version" {
    default     = null
}

variable "python_version" {
    default     = null
}

variable "ruby_version" {
    default     = null
}


variable "app_settings" {
    #
}