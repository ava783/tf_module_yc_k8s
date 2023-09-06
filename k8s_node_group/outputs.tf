output "node_network_list" {
  value = "${yandex_kubernetes_node_group.kubernetes_node_group.instance_template[0].network_interface}"
}