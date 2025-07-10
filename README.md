
# gcp-terraform-finte-service-account-setup

GCP terraform module to create the FinTe Read Only service account.

# Pre requirements

Make sure the service account that will run this terraform script has the following roles granted.
* Organization Administrator
* Organization Policy Administrator
* Organization Role Administrator
* Service Account Admin
* Service Account Key Admin
* Service Usage Admin

## Example Usage

The example below uses `ref=main` (which is appended in the URL),  but it is recommended to use a specific tag version (i.e. `ref=1.0.0`) to avoid breaking changes. Go to the release page for a list of published versions. [releases page](https://github.com/finte-ai/gcp-terraform-finte-service-account-setup/releases) for a list of published versions.

Replace `YOUR_ORGANIZATION_DOMAIN` with the organization domain. i.e. `your_org.com`.
```
module "service_account_creation" {
  source = "git::https://github.com/finte-ai/gcp-terraform-finte-service-account-setup.git?ref=main"
  gcp_org_domain = "YOUR_ORGANIZATION_DOMAIN"
  gcp_project_id = "YOUR_PROJECT_ID" # Service accounts are GCP resources that must belong to a project. Which project you choose is not important.
  # finte_service_account_name = "YOUR_SERVICE_ACCOUNT_NAME" # if it's unset, the default name is FinTeReadOnly
}

output "finte_service_account_key" {
  value       = module.finte_service_account.finte_service_account_key
  sensitive   = true
  description = "Service Account Key for FinTe integration"
}
```

After you apply this terraform, run the following command to retrieve the key file `finte-gcp-private-key.json`
```
terraform output -raw finte_service_account_key |pbcopy
```

## Troubleshooting

1. Fixing `CUSTOM_ORG_POLICY_VIOLATION: Error creating service account: googleapi: Error 400: Operation denied by org policy: ["constraints/iam.managed.disableServiceAccountCreation"]` issue

   * Go to the [IAM Organization Policies](https://console.cloud.google.com/iam-admin/orgpolicies) page.
   * Make sure the project where the service account will be stored is selected top left in the console.
   * Type `iam.managed.disableServiceAccountCreation` on the `🔽 Filter` bar and select the policy.
   * Click over `📝 MANAGE POLICY` button.
   * Go to `Policy source` and select the `Override parent's policy` option.
   * Scroll down a little and open up the `Enforced` rule.
   * Make sure the `Enforcement` section is `Off`.
   * Click `SET POLICY` to save changes.
   * Run this script again.

1. Fixing `CUSTOM_ORG_POLICY_VIOLATION: Error creating service account key: googleapi: Error 400: Operation denied by org policy: ["constraints/iam.managed.disableServiceAccountKeyCreation": "This constraint, when enforced, blocks service account key creation."].` issue.
   * Go to the [IAM Organization Policies](https://console.cloud.google.com/iam-admin/orgpolicies) page.
   * Make sure the project where the service account will be stored is selected top left in the console.
   * Type `iam.managed.disableServiceAccountKeyCreation` on the `🔽 Filter` bar and select the policy.
   * Click over `📝 MANAGE POLICY` button.
   * Go to `Policy source` and select the `Override parent's policy` option.
   * Scroll down a little and open up the `Enforced` rule.
   * Make sure the `Enforcement` section is `Off`.
   * Click `SET POLICY` to save changes.
   * Run this script again.

## Setup

The following steps demonstrate how to connect GCP in FinTe when using this terraform module.

1. Add the code above to your terraform project.
2. Make sure the service account to authenticate this script has the roles `Organization Administrator`, `Service Account Admin`, `Service Account Key Admin` and ` Service Usage Admin`.
3. Replace `main` in `ref=main` with the latest version from the [releases page](https://github.com/finte-ai/gcp-terraform-finte-service-account-setup/releases).
4. Replace `YOUR_ORGANIZATION_DOMAIN` with the GCP organization domain.
5. Replace `YOUR_PROJECT_ID` with a project in your organization which the service account should belong to.
6. Replace the given `finte_service_account_name` if you don't want the Service Account name to be the default: `FinTeReadOnly`.
8. Back in your terminal, run `terraform init` to download/update the module.
9. Run `terraform apply` and **IMPORTANT** review the plan output before typing `yes`.
10. If successful, run the command to copy the contents of the private key json:
     - `terraform output -raw finte_service_account_key |pbcopy` .
12. Go to the GCP connection and paste the contents of the `finte-gcp-private-key.json` file into the text field labeled `Private Key (JSON)`.
13. If you have not already done so, create the BigQuery billing dataset as you will need Project ID and Dataset ID where you are storing the billing data. See the [gcp-terraform-finte-billing-data-setup](https://github.com/finte-public-ai/gcp-terraform-finte-billing-data-setup) for more information.
13. Click the `Create connection` button.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >=5.16.0, <7.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >=5.16.0, <7.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_organization_iam_member.finte_organization_roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_member) | resource |
| [google_project_iam_member.finte_project_roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.services](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.finte](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_key.finte_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | resource |
| [google_organization.gcp_organization](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_finte_service_account_name"></a> [finte\_service\_account\_name](#input\_finte\_service\_account\_name) | Name of the service account | `string` | `"FinTeReadOnly"` | no |
| <a name="input_gcp_org_domain"></a> [gcp\_org\_domain](#input\_gcp\_org\_domain) | GCP Organization domain. | `string` | n/a | yes |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | Project identifier where the service account will be created. | `string` | n/a | yes |
| <a name="input_gcp_roles"></a> [gcp\_roles](#input\_gcp\_roles) | List of roles to assign to the service account. | `list(string)` | <pre>[<br/>  "roles/browser",<br/>  "roles/viewer",<br/>  "roles/cloudasset.viewer",<br/>  "roles/monitoring.viewer",<br/>  "roles/recommender.viewer"<br/>]</pre> | no |
| <a name="input_gcp_services"></a> [gcp\_services](#input\_gcp\_services) | List of services to enable. | `list(string)` | <pre>[<br/>  "cloudresourcemanager.googleapis.com",<br/>  "monitoring.googleapis.com",<br/>  "cloudasset.googleapis.com",<br/>  "cloudbilling.googleapis.com",<br/>  "recommender.googleapis.com"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_finte_service_account_key"></a> [finte\_service\_account\_key](#output\_finte\_service\_account\_key) | FinTeService Account Private Key |
<!-- END_TF_DOCS -->
