module "example" {
  source = "../.."

  name                = "example-ai"
  resource_group_name = "example-rg"
  workspace_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.OperationalInsights/workspaces/example-law"
}
