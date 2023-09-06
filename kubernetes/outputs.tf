output "kuber_intv4" {
  value = "${yandex_kubernetes_cluster.kubernetes_master.master[0].internal_v4_endpoint}"
}
output "kuber_ca" {
  value = "${yandex_kubernetes_cluster.kubernetes_master.master[0].cluster_ca_certificate}"
}
output "cluster_id" {
  value = "${yandex_kubernetes_cluster.kubernetes_master.id}"
}