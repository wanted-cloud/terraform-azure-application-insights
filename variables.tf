variable "name" {
  description = "Name of the Application Insights resource."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group in which the Application Insights resource will be created."
  type        = string
}

variable "workspace_id" {
  description = "The ID of the Log Analytics workspace to associate with this Application Insights resource. Workspace-based Application Insights is required."
  type        = string
}

variable "location" {
  description = "Location of the resource group in which the Application Insights resource will be created, if not set it will be the same as the resource group."
  type        = string
  default     = ""
}

variable "application_type" {
  description = "Specifies the type of Application Insights to create. Possible values are web, other, java, MobileCenter, Node.JS, ios, phone, store."
  type        = string
  default     = "web"

  validation {
    condition     = contains(["web", "other", "java", "MobileCenter", "Node.JS", "ios", "phone", "store"], var.application_type)
    error_message = "Invalid application_type. Allowed values: web, other, java, MobileCenter, Node.JS, ios, phone, store."
  }
}

variable "retention_in_days" {
  description = "The retention period in days for Application Insights data."
  type        = number
  default     = 90

  validation {
    condition     = contains([30, 60, 90, 120, 180, 270, 365, 550, 730], var.retention_in_days)
    error_message = "Invalid retention_in_days. Allowed values: 30, 60, 90, 120, 180, 270, 365, 550, 730."
  }
}

variable "sampling_percentage" {
  description = "Specifies the percentage of the data produced by the application monitored by Application Insights that is sampled for use."
  type        = number
  default     = 100
}

variable "disable_ip_masking" {
  description = "Whether IP masking is disabled. By default the real client IP is masked."
  type        = bool
  default     = false
}

variable "local_authentication_disabled" {
  description = "Whether local authentication is disabled for Application Insights."
  type        = bool
  default     = false
}

variable "internet_ingestion_enabled" {
  description = "Whether internet ingestion is enabled for Application Insights."
  type        = bool
  default     = true
}

variable "internet_query_enabled" {
  description = "Whether internet query is enabled for Application Insights."
  type        = bool
  default     = true
}

variable "force_customer_storage_for_profiler" {
  description = "Whether to force customer storage for the profiler."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the Application Insights resource."
  type        = map(string)
  default     = {}
}

variable "web_tests" {
  description = "List of Application Insights Standard Web Tests to create."
  type = list(object({
    name          = string
    geo_locations = list(string)
    frequency     = optional(number, 300)
    timeout       = optional(number, 30)
    enabled       = optional(bool, true)
    retry_enabled = optional(bool, true)
    description   = optional(string)
    request = object({
      url                              = string
      http_verb                        = optional(string, "GET")
      body                             = optional(string)
      parse_dependent_requests_enabled = optional(bool, false)
      follow_redirects_enabled         = optional(bool, true)
      header = optional(list(object({
        name  = string
        value = string
      })), [])
    })
    validation_rules = optional(object({
      expected_status_code        = optional(number, 200)
      ssl_check_enabled           = optional(bool, false)
      ssl_cert_remaining_lifetime = optional(number)
      content = optional(object({
        content_match      = string
        ignore_case        = optional(bool, false)
        pass_if_text_found = optional(bool, true)
      }))
    }))
    tags = optional(map(string), {})
  }))
  default = []
}

variable "smart_detector_alert_rules" {
  description = "List of Smart Detector alert rules scoped to this Application Insights resource."
  type = list(object({
    name                = string
    detector_type       = string
    severity            = optional(string, "Sev3")
    frequency           = optional(string, "PT1M")
    description         = optional(string)
    enabled             = optional(bool, true)
    action_group_ids    = list(string)
    throttling_duration = optional(string)
    tags                = optional(map(string), {})
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.smart_detector_alert_rules : contains(["Sev0", "Sev1", "Sev2", "Sev3", "Sev4"], r.severity)
    ])
    error_message = "Invalid severity in smart_detector_alert_rules. Allowed values: Sev0, Sev1, Sev2, Sev3, Sev4."
  }

  validation {
    condition = alltrue([
      for r in var.smart_detector_alert_rules : can(regex("^P(T\\d+[HMS])+$|^P\\d+D(T\\d+[HMS])*$", r.frequency))
    ])
    error_message = "Invalid frequency in smart_detector_alert_rules. Must be an ISO 8601 duration string (e.g. PT1M, PT5M, PT1H)."
  }
}
