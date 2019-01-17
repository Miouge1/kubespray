variable "cluster_name" {
  default = "kubespray"
}

variable "packet_auth_token" {
  default = "TF_VAR_packet_auth_token environment variable is not defined"
}

variable "packet_project_id" {
  default = "TF_VAR_packet_project_id environment variable is not defined"
}

variable "operating_system" {
  default = "ubuntu_16_04"
}

variable "public_key_path" {
  description = "The path of the ssh pub key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "billing_cycle" {
  default = "hourly"
}

variable "facility" {
  default = "dfw2"
}

variable "plan" {
  default = "c2.medium.x86"
}

variable "number_of_k8s_masters" {
  default = 0
}

variable "number_of_k8s_masters_no_etcd" {
  default = 0
}

variable "number_of_etcd" {
  default = 0
}

variable "number_of_k8s_nodes" {
  default = 0
}
