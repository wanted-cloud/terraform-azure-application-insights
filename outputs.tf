output "application_insights" {
  description = "The Application Insights resource."
  value       = azurerm_application_insights.this
}

output "web_tests" {
  description = "Map of Application Insights Standard Web Test resources, keyed by web test name."
  value       = azurerm_application_insights_standard_web_test.this
}

output "smart_detector_alert_rules" {
  description = "Map of Smart Detector alert rule resources, keyed by rule name."
  value       = azurerm_monitor_smart_detector_alert_rule.this
}
