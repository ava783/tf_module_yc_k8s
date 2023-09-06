# https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

# Создаем кластер кубернетес
resource "yandex_kubernetes_cluster" "kubernetes_master" {
  # Указываем его имя
  name        = var.name_kuber
  folder_id   = var.folder_id
  # Указываем, к какой сети он будет подключен
  network_id = var.network_id
  cluster_ipv4_range = var.cluster_ipv4_range
  service_ipv4_range = var.service_ipv4_range

  # Указываем, что мастера располагаются в регионе ru-central и какие subnets использовать для каждой зоны
  master {
    # if multipe nodes
    # regional {
    # if one node
    #zonal { 
    #  # https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster#zone
    #  #~region = "ru-central1"
#
    #  # location {
    #    zone      = var.zone
    #    subnet_id = var.subnet_id
    #  }

    dynamic "zonal" {
      for_each = var.regional ? [] : [1]
      content {
        zone      = var.subnet.zone
        subnet_id = var.subnet.id
     }
    }

    dynamic "regional" {
      for_each = var.regional ? [1] : []
      content {
        region = var.region
        dynamic "location" {
          for_each = var.subnet
          content {
            zone      = location.value.zone
            subnet_id = location.value.id
         }
        }
      }
    }
    #   location {
    #     zone      = yandex_vpc_subnet.internal-b.zone
    #     subnet_id = yandex_vpc_subnet.internal-b.id
    #   }

    #   location {
    #     zone      = yandex_vpc_subnet.internal-c.zone
    #     subnet_id = yandex_vpc_subnet.internal-c.id
    #   }
    

    # Указываем версию Kubernetes
    version   = var.version_kube
    # Назначаем внешний ip master нодам, чтобы мы могли подключаться к ним извне
    public_ip = false
  }

  # Указываем канал обновлений
  release_channel = "STABLE"
  network_policy_provider = "CALICO"

  # Указываем сервисный аккаунт, который будут использовать ноды, и кластер для управления нодами
  node_service_account_id = var.service_account_id
  service_account_id      = var.service_account_id
}