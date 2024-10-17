#data "azurerm_management_group" "rootmg" {
#  name = "aa141e2a-a555-4d1b-a870-173addaf2cb3"
#}

#data "azurerm_management_group" "devmg" {
#  name = "Dev1"
#}

data "azurerm_subscription" "current" {}

#output "display_id" {
#  value = data.azurerm_management_group.rootmg.id
#}

#output "display_submg_id" {
#  value = data.azurerm_management_group.devmg
#}

output "display_sub_id" {
  value = data.azurerm_subscription.current.id
}

#########################################################################
#
#
#
#########################################################################
resource "azurerm_policy_definition" "acr_premium_tier" {
  name         = "acrpremiumtier"
  policy_type  = "Custom"
  mode         = "All"
#  management_group_id = data.azurerm_management_group.devmg.id
  management_group_id = "Dev1"
  display_name = "Audit premium service tier must be used for Container Registry - TF"

  metadata = <<METADATA
    {
    "category": "Container Registry"
    }
METADATA

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.ContainerRegistry/registries"
          },
          {
            "not": {
              "field": "Microsoft.ContainerRegistry/registries/sku.tier",
              "equals": "Standard"
            }
          }
        ]
      },
      "then": {
        "effect": "audit"
      }
    }
POLICY_RULE

}

#resource "azurerm_subscription_policy_assignment" "acr_sku_on_sub" {
#  name                 = "acr_sku_on_sub"
#  display_name = "acr_sku_acr_sku_on_sub_assignment_on_yibo_sub"
#  policy_definition_id = azurerm_policy_definition.acr_premium_tier.id
#  subscription_id      = data.azurerm_subscription.current.id
#}

