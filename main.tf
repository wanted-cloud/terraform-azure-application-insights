/*
 * # wanted-cloud/terraform-azure-application-insights
 *
 * Azure Application Insights (workspace-based) Terraform building block module with bundled standard web tests and smart detector alert rules.
 */

resource "azurerm_application_insights" "this" {
  name                = var.name
  location            = var.location != "" ? var.location : data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  workspace_id        = var.workspace_id

  application_type                    = var.application_type
  retention_in_days                   = var.retention_in_days
  sampling_percentage                 = var.sampling_percentage
  disable_ip_masking                  = var.disable_ip_masking
  local_authentication_disabled       = var.local_authentication_disabled
  internet_ingestion_enabled          = var.internet_ingestion_enabled
  internet_query_enabled              = var.internet_query_enabled
  force_customer_storage_for_profiler = var.force_customer_storage_for_profiler

  tags = merge(local.metadata.tags, var.tags)

  timeouts {
    create = try(
      local.metadata.resource_timeouts["azurerm_application_insights"]["create"],
      local.metadata.resource_timeouts["default"]["create"]
    )
    read = try(
      local.metadata.resource_timeouts["azurerm_application_insights"]["read"],
      local.metadata.resource_timeouts["default"]["read"]
    )
    update = try(
      local.metadata.resource_timeouts["azurerm_application_insights"]["update"],
      local.metadata.resource_timeouts["default"]["update"]
    )
    delete = try(
      local.metadata.resource_timeouts["azurerm_application_insights"]["delete"],
      local.metadata.resource_timeouts["default"]["delete"]
    )
  }
}
