variable "name_kuber" {
  type = string
}

variable "network_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "subnet" {
  type = any
}

variable "service_account_id" {
  type = string
}

variable "version_kube" {
  type = string
}

variable "cluster_ipv4_range" {
  type = string
}

variable "service_ipv4_range" {
  type = string
}

variable "regional" {
  type = bool
  default = false
}

variable "region" {
  type = string
  default = "ru-central1"
}