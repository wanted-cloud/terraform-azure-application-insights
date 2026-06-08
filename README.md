<!-- BEGIN_TF_DOCS -->
# wanted-cloud/terraform-azure-application-insights

Azure Application Insights (workspace-based) Terraform building block module with bundled standard web tests and smart detector alert rules.

## Table of contents

- [Requirements](#requirements)
- [Providers](#providers)
- [Variables](#inputs)
- [Outputs](#outputs)
- [Resources](#resources)
- [Usage](#usage)
- [Contributing](#contributing)

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>=4.20.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (4.76.0)

## Required Inputs

The following input variables are required:

### <a name="input_name"></a> [name](#input\_name)

Description: Name of the Application Insights resource.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Name of the resource group in which the Application Insights resource will be created.

Type: `string`

### <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id)

Description: The ID of the Log Analytics workspace to associate with this Application Insights resource. Workspace-based Application Insights is required.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_application_type"></a> [application\_type](#input\_application\_type)

Description: Specifies the type of Application Insights to create. Possible values are web, other, java, MobileCenter, Node.JS, ios, phone, store.

Type: `string`

Default: `"web"`

### <a name="input_disable_ip_masking"></a> [disable\_ip\_masking](#input\_disable\_ip\_masking)

Description: Whether IP masking is disabled. By default the real client IP is masked.

Type: `bool`

Default: `false`

### <a name="input_force_customer_storage_for_profiler"></a> [force\_customer\_storage\_for\_profiler](#input\_force\_customer\_storage\_for\_profiler)

Description: Whether to force customer storage for the profiler.

Type: `bool`

Default: `false`

### <a name="input_internet_ingestion_enabled"></a> [internet\_ingestion\_enabled](#input\_internet\_ingestion\_enabled)

Description: Whether internet ingestion is enabled for Application Insights.

Type: `bool`

Default: `true`

### <a name="input_internet_query_enabled"></a> [internet\_query\_enabled](#input\_internet\_query\_enabled)

Description: Whether internet query is enabled for Application Insights.

Type: `bool`

Default: `true`

### <a name="input_local_authentication_disabled"></a> [local\_authentication\_disabled](#input\_local\_authentication\_disabled)

Description: Whether local authentication is disabled for Application Insights.

Type: `bool`

Default: `false`

### <a name="input_location"></a> [location](#input\_location)

Description: Location of the resource group in which the Application Insights resource will be created, if not set it will be the same as the resource group.

Type: `string`

Default: `""`

### <a name="input_metadata"></a> [metadata](#input\_metadata)

Description: Metadata definitions for the module, this is optional construct allowing override of the module defaults defintions of validation expressions, error messages, resource timeouts and default tags.

Type:

```hcl
object({
    resource_timeouts = optional(
      map(
        object({
          create = optional(string, "30m")
          read   = optional(string, "5m")
          update = optional(string, "30m")
          delete = optional(string, "30m")
        })
      ), {}
    )
    tags                     = optional(map(string), {})
    validator_error_messages = optional(map(string), {})
    validator_expressions    = optional(map(string), {})
  })
```

Default: `{}`

### <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days)

Description: The retention period in days for Application Insights data.

Type: `number`

Default: `90`

### <a name="input_sampling_percentage"></a> [sampling\_percentage](#input\_sampling\_percentage)

Description: Specifies the percentage of the data produced by the application monitored by Application Insights that is sampled for use.

Type: `number`

Default: `100`

### <a name="input_smart_detector_alert_rules"></a> [smart\_detector\_alert\_rules](#input\_smart\_detector\_alert\_rules)

Description: List of Smart Detector alert rules scoped to this Application Insights resource.

Type:

```hcl
list(object({
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
```

Default: `[]`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: A map of tags to assign to the Application Insights resource.

Type: `map(string)`

Default: `{}`

### <a name="input_web_tests"></a> [web\_tests](#input\_web\_tests)

Description: List of Application Insights Standard Web Tests to create.

Type:

```hcl
list(object({
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
```

Default: `[]`

## Outputs

The following outputs are exported:

### <a name="output_application_insights"></a> [application\_insights](#output\_application\_insights)

Description: The Application Insights resource.

### <a name="output_smart_detector_alert_rules"></a> [smart\_detector\_alert\_rules](#output\_smart\_detector\_alert\_rules)

Description: Map of Smart Detector alert rule resources, keyed by rule name.

### <a name="output_web_tests"></a> [web\_tests](#output\_web\_tests)

Description: Map of Application Insights Standard Web Test resources, keyed by web test name.

## Resources

The following resources are used by this module:

- [azurerm_application_insights.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) (resource)
- [azurerm_application_insights_standard_web_test.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_standard_web_test) (resource)
- [azurerm_monitor_smart_detector_alert_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_smart_detector_alert_rule) (resource)
- [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)

## Usage

> For more detailed examples navigate to `examples` folder of this repository.

Module was also published via Terraform Registry and can be used as a module from the registry.

```hcl
module "example" {
  source  = "wanted-cloud/..."
  version = "x.y.z"
}
```

### Basic usage example

The minimal usage for the module is as follows:

```hcl
module "example" {
  source = "../.."

  name                = "example-ai"
  resource_group_name = "example-rg"
  workspace_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.OperationalInsights/workspaces/example-law"
}
```
## Contributing

_Contributions are welcomed and must follow [Code of Conduct](https://github.com/wanted-cloud/.github?tab=coc-ov-file) and common [Contributions guidelines](https://github.com/wanted-cloud/.github/blob/main/docs/CONTRIBUTING.md)._

> If you'd like to report security issue please follow [security guidelines](https://github.com/wanted-cloud/.github?tab=security-ov-file).
---
<sup><sub>_2025 &copy; All rights reserved - WANTED.solutions s.r.o._</sub></sup>
<!-- END_TF_DOCS -->