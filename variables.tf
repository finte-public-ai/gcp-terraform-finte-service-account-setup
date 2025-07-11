variable "gcp_project_id" {
  type        = string
  description = "Project identifier where the service account will be created."
}

variable "gcp_org_domain" {
  type        = string
  description = "GCP Organization domain."
}

variable "gcp_services" {
  type = list(string)
  default = [
    "cloudresourcemanager.googleapis.com",
    "monitoring.googleapis.com",
    "cloudasset.googleapis.com",
    "cloudbilling.googleapis.com",
    "recommender.googleapis.com"
  ]
  description = "List of services to enable."
}

variable "gcp_roles" {
  type        = list(string)
  description = "List of roles to assign to the service account."
  default = [
    "roles/browser",
    "roles/viewer",
    "roles/cloudasset.viewer",
    "roles/monitoring.viewer",
    "roles/recommender.viewer",
  ]
}

variable "finte_service_account_name" {
  type        = string
  description = "Name of the service account"
  default     = "FinTeReadOnly"
}
