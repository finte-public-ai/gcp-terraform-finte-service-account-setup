output "finte_service_account_key" {
  value       = base64decode(google_service_account_key.finte_key.private_key)
  description = "FinTeService Account Private Key"
  sensitive   = true
}