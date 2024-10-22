#data "azurerm_management_group" "rootmg" {
#  name = "aa141e2a-a555-4d1b-a870-173addaf2cb3"
#}

data "azurerm_management_group" "devmg" {
  name = "Dev1"
}

data "azurerm_subscription" "current" {}

#output "display_id" {
#  value = data.azurerm_management_group.rootmg.id
#}

# data "azurerm_resource_group" "acr_terraform_rg" {
#   name = "acr_terraform_test"
# }

data "azurerm_policy_definition_built_in" "acr_disable_public_access" {
  display_name = "Public network access should be disabled for Container registries"
}

data "azurerm_policy_definition_built_in" "allowed_location" {
  display_name = "Allowed locations"
}

output "allowed_location_policy_id" {
  value = data.azurerm_policy_definition_built_in.allowed_location.id
}

output "acr_disable_public_access_policy_id" {
  value = data.azurerm_policy_definition_built_in.acr_disable_public_access.id
}

# output "display_rg_id" {
#   value = data.azurerm_resource_group.acr_terraform_rg.id
# }

output "display_submg_id" {
  value = data.azurerm_management_group.devmg.display_name
}

output "display_sub_id" {
  value = data.azurerm_subscription.current.id
}

#########################################################################
#
# Test
#
#########################################################################
resource "azurerm_policy_definition" "acr_premium_tier" {
  name         = "acrpremiumtier"
  policy_type  = "Custom"
  mode         = "All"
  management_group_id = data.azurerm_management_group.devmg.id
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

# resource "azurerm_subscription_policy_assignment" "acr_sku_on_sub" {
#   name                 = "acr_sku_on_sub"
#   display_name = "acr_sku_assignment_on_lyb53708621_sub"
#   policy_definition_id = azurerm_policy_definition.acr_premium_tier.id
#   subscription_id      = data.azurerm_subscription.current.id
# }

# resource "azurerm_resource_group_policy_assignment" "acr_terraform_rg_check" {
#   name                 = "acr_terraform_rg_check"
#   display_name         = "acr_check_for_rg_acr_terraform"
#   resource_group_id    = data.azurerm_resource_group.acr_terraform_rg.id
#   policy_definition_id = azurerm_policy_definition.acr_premium_tier.id
# }

#########################################################################
#
# Policy Initiatives
#
#########################################################################
resource "azurerm_policy_set_definition" "acr_policy_set" {
  name         = "acr_policy_set"
  policy_type  = "Custom"
  management_group_id = data.azurerm_management_group.devmg.id
  display_name = "Yibo ACR Terraform Policy Set"

  parameters = <<PARAMETERS
    {
        "allowedLocations": {
            "type": "Array",
            "defaultValue": ["East Asia"],
            "metadata": {
                "description": "The list of allowed locations for resources.",
                "displayName": "Allowed locations",
                "strongType": "location"
            }

        }
    }
PARAMETERS

  policy_definition_reference {
    policy_definition_id = data.azurerm_policy_definition_built_in.acr_disable_public_access.id
  }

  # policy_definition_reference {
  #   policy_definition_id = azurerm_policy_definition.acr_premium_tier.id
  # }

  policy_definition_reference {
    policy_definition_id = data.azurerm_policy_definition_built_in.allowed_location.id
    parameter_values     = <<VALUE
    {
      "listOfAllowedLocations": {"value": "[parameters('allowedLocations')]"}
    }
    VALUE
  }
}