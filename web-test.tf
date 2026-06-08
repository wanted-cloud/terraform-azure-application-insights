resource "azurerm_application_insights_standard_web_test" "this" {
  for_each = { for wt in var.web_tests : wt.name => wt }

  name                    = each.value.name
  resource_group_name     = data.azurerm_resource_group.this.name
  location                = var.location != "" ? var.location : data.azurerm_resource_group.this.location
  application_insights_id = azurerm_application_insights.this.id
  geo_locations           = each.value.geo_locations
  frequency               = each.value.frequency
  timeout                 = each.value.timeout
  enabled                 = each.value.enabled
  retry_enabled           = each.value.retry_enabled
  description             = each.value.description

  request {
    url                              = each.value.request.url
    http_verb                        = each.value.request.http_verb
    body                             = each.value.request.body
    parse_dependent_requests_enabled = each.value.request.parse_dependent_requests_enabled
    follow_redirects_enabled         = each.value.request.follow_redirects_enabled

    dynamic "header" {
      for_each = each.value.request.header
      content {
        name  = header.value.name
        value = header.value.value
      }
    }
  }

  dynamic "validation_rules" {
    for_each = each.value.validation_rules != null ? [each.value.validation_rules] : []
    content {
      expected_status_code        = validation_rules.value.expected_status_code
      ssl_check_enabled           = validation_rules.value.ssl_check_enabled
      ssl_cert_remaining_lifetime = validation_rules.value.ssl_cert_remaining_lifetime

      dynamic "content" {
        for_each = validation_rules.value.content != null ? [validation_rules.value.content] : []
        content {
          content_match      = content.value.content_match
          ignore_case        = content.value.ignore_case
          pass_if_text_found = content.value.pass_if_text_found
        }
      }
    }
  }

  tags = merge(local.metadata.tags, each.value.tags)

  timeouts {
    create = try(
      local.metadata.resource_timeouts["azurerm_application_insights_standard_web_test"]["create"],
      local.metadata.resource_timeouts["default"]["create"]
    )
    read = try(
      local.metadata.resource_timeouts["azurerm_application_insights_standard_web_test"]["read"],
      local.metadata.resource_timeouts["default"]["read"]
    )
    update = try(
      local.metadata.resource_timeouts["azurerm_application_insights_standard_web_test"]["update"],
      local.metadata.resource_timeouts["default"]["update"]
    )
    delete = try(
      local.metadata.resource_timeouts["azurerm_application_insights_standard_web_test"]["delete"],
      local.metadata.resource_timeouts["default"]["delete"]
    )
  }
}
