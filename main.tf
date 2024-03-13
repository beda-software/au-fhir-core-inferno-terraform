locals {
  namespace = "inferno"
  manifests = fileset(path.module, "manifests/*.yaml")
}


module "inferno" {
  source = "./au_fhir_inferno"

  base_url = "https://au-inferno.beda.software/"
}

resource "google_compute_ssl_policy" "ssl_policy" {
  project         = var.project_id
  name            = "gke-ingress-ssl-policy"
  min_tls_version = "TLS_1_2"
}

resource "kubernetes_manifest" "ingress" {
  for_each = { for m in local.manifests : m => "${path.module}/${m}" }

  manifest = yamldecode(templatefile(each.value, {
    namespace      = local.namespace
    public_ip_name = google_compute_global_address.ingress_ip.name

  }))
  depends_on = [module.inferno]
}
