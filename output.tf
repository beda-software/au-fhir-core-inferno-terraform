output "ingress_ip" {
  description = "Ingress ip"
  value       = google_compute_global_address.ingress_ip.address
}
