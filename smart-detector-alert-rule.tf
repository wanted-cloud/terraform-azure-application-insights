resource "azurerm_monitor_smart_detector_alert_rule" "this" {
  for_each = { for r in var.smart_detector_alert_rules : r.name => r }

  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.this.name
  detector_type       = each.value.detector_type
  scope_resource_ids  = [azurerm_application_insights.this.id]
  severity            = each.value.severity
  frequency           = each.value.frequency
  description         = each.value.description
  enabled             = each.value.enabled
  throttling_duration = each.value.throttling_duration

  action_group {
    ids = each.value.action_group_ids
  }

  tags = merge(local.metadata.tags, each.value.tags)

  timeouts {
    create = try(
      local.metadata.resource_timeouts["azurerm_monitor_smart_detector_alert_rule"]["create"],
      local.metadata.resource_timeouts["default"]["create"]
    )
    read = try(
      local.metadata.resource_timeouts["azurerm_monitor_smart_detector_alert_rule"]["read"],
      local.metadata.resource_timeouts["default"]["read"]
    )
    update = try(
      local.metadata.resource_timeouts["azurerm_monitor_smart_detector_alert_rule"]["update"],
      local.metadata.resource_timeouts["default"]["update"]
    )
    delete = try(
      local.metadata.resource_timeouts["azurerm_monitor_smart_detector_alert_rule"]["delete"],
      local.metadata.resource_timeouts["default"]["delete"]
    )
  }
}
