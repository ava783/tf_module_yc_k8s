variable "name" {
  type = string
}
  
variable "subnet_id" {
  type = list(string)
}

variable "version_kube" {
  type = string
}

variable "preemptible" {
  type = bool
}

variable "worker_nodes" {
  type = number
}

variable "resource_cores" {
  type = number
}

variable "resource_memory" {
  type = number
}

variable "auto_scale" {
    type = bool
}

variable "zones" {
  type = list(string)
}

variable "disk_type" {
  type = string
}

variable "disk_size" {
  type = number
}

variable "target_cluster" {
  type = string
}