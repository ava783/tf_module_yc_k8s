# https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_kubernetes_node_group" "kubernetes_node_group" {
  # Указываем, к какому кластеру они принадлежат
  cluster_id  = var.target_cluster
  # Указываем название группы узлов
  name        = var.name
  # И версию
  version     = var.version_kube

  # Настраиваем шаблон виртуальной машины
  instance_template {
    platform_id = "standard-v1"
    metadata = {
      ssh-keys = "user:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDjvYnPTlV8+g9utABo3Mla6TAHWZaMhSU4GU7DlMBaBY9f7JNlwlW9L8D0OgTDwvhC0yO+JrzVOtpVKJheSNvrtY/f81QoRiVPmhpyk2oGppIHifHDRm5cF/T1izIorKBVJ2eQQYglrQlfKat61IqIEMObOWy5AAtpffYdfh0EGauVgom4sy2zhuYkzTKmwwhbPHqRCclPpar5+U2bVh/38NdP6AuC7e/wKUFrH5iRgiWEoxlqKAjJjRKfpXNKaqOpAnJUObHiD/f2+weiIR2cPhOIpq6ebwcys9HS6T5M4TVXF3PqFQc7maBpi1m+B6s99hIHjCCGP5pe9yFlmMjxlN4nbcaiWSWt0HN+lS+cyg4upwvDYcL7EWRoNn6LwLKcX8vyybM2A7yJJkOAZi1VcHfdf5Njl827zhyOVlc5MsRKtt4iylwLbzaSuCLretM4J15uCdKujZ/8+LtreGK/M7heSQWIQUEuIpz6pqT4wsYKH895fGgoHhgP7l4Bmv8="

}
    
    network_interface {
      nat = false
      subnet_ids = var.subnet_id
    #   subnet_ids = ["${yandex_vpc_subnet.tir-net-central1-a.id}", "${yandex_vpc_subnet.internal-b.id}", "${yandex_vpc_subnet.internal-c.id}"]
    }

    resources {
      # core_fraction = 20 # Данный параметр позволяет уменьшить производительность CPU и сильно уменьшить затраты на инфраструктуру
      # the specified memory size is not available with 20 cores and 100% core fraction on platform "standard-v1"; allowed memory size: 20GB, 40GB, 60GB, 80GB, 100GB, 120GB, 140GB, 160GB.
      memory        = var.resource_memory
      cores         = var.resource_cores
    }

    boot_disk {
      type = var.disk_type
      size = var.disk_size
    }

    scheduling_policy {
      preemptible = var.preemptible
    }
  }

  # Настраиваем политику масштабирования — в данном случае у нас группа фиксирована и в ней находятся 2 узла
  scale_policy {
    dynamic "fixed_scale" {
      for_each = var.auto_scale ? [] : [1]
      content {
        size = var.worker_nodes
      }
    }
    # auto_scale {
    #   min = 2
    #   max = 10
    #   initial = 2
    # }
  }

  # В каких зонах можно создавать машинки — указываем все зоны
  allocation_policy {
    dynamic "location" {
      for_each = var.zones
      content {
        zone = location.value
     }
    }

    #location {
    #  zone = "ru-central1-a"
    #}

    # location {
    #   zone = "ru-central1-c"
    # }
  }

  # Отключаем автоматический апгрейд
  maintenance_policy {
    auto_upgrade = false
    auto_repair  = true
  }
}
