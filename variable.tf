variable "log_analytics_workspace_name" {
    description = ""
    type        = string
}
variable "location" {
    description = ""
    type        = string
}

variable "resource_group_name" {
    description = ""
    type        = string
}

variable "application_insights_name" {
    description = ""
    type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "sku" {
    default   = "PerGB2018"
}

variable "retention_in_days" {
    default   = 30
}