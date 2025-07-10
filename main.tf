# get organization data
data "google_organization" "gcp_organization" {
  domain = var.gcp_org_domain
}

# set project id in local variable
locals {
  PROJECT_ID = var.gcp_project_id
}

# enable services
resource "google_project_service" "services" {
  for_each           = toset(var.gcp_services)
  service            = each.value
  disable_on_destroy = false
  project            = local.PROJECT_ID
}

# creation of the service account
resource "google_service_account" "finte" {
  account_id   = lower(var.finte_service_account_name)
  display_name = var.finte_service_account_name
  project      = local.PROJECT_ID
}

# create json key file
resource "google_service_account_key" "finte_key" {
  service_account_id = google_service_account.finte.id
}

resource "google_organization_iam_member" "finte_organization_roles" {
  for_each = toset(var.gcp_roles)
  org_id   = data.google_organization.gcp_organization.org_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.finte.email}"
}
