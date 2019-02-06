# Configure the Packet Provider
provider "packet" {
}

resource "packet_ssh_key" "k8s" {
  count      = "${var.public_key_path != "" ? 1 : 0}"
  name       = "kubernetes-${var.cluster_name}"
  public_key = "${chomp(file(var.public_key_path))}"
}

resource "packet_device" "k8s_master" {
  depends_on = ["packet_ssh_key.k8s"]

  count            = "${var.number_of_k8s_masters}"
  hostname         = "${var.cluster_name}-k8s-master-${count.index+1}"
  plan             = "${var.plan_k8s_masters}"
  facility         = "${var.facility}"
  operating_system = "${var.operating_system}"
  billing_cycle    = "${var.billing_cycle}"
  project_id       = "${var.packet_project_id}"
  tags             = ["cluster-${var.cluster_name}", "k8s-cluster", "kube-master", "etcd", "kube-node"]

}

resource "packet_bgp_session" "k8s_master" {
    count          = "${var.use_bgp * var.number_of_k8s_masters}"
    device_id      = "${element(packet_device.k8s_master.*.id, count.index)}"
    address_family = "ipv4"
}

resource "packet_device" "k8s_master_no_etcd" {
  depends_on = ["packet_ssh_key.k8s"]

  count            = "${var.number_of_k8s_masters_no_etcd}"
  hostname         = "${var.cluster_name}-k8s-master-${count.index+1}"
  plan             = "${var.plan_k8s_masters_no_etcd}"
  facility         = "${var.facility}"
  operating_system = "${var.operating_system}"
  billing_cycle    = "${var.billing_cycle}"
  project_id       = "${var.packet_project_id}"
  tags             = ["cluster-${var.cluster_name}", "k8s-cluster", "kube-master"]
}

resource "packet_device" "k8s_etcd" {
  depends_on = ["packet_ssh_key.k8s"]

  count            = "${var.number_of_etcd}"
  hostname         = "${var.cluster_name}-etcd-${count.index+1}"
  plan             = "${var.plan_etcd}"
  facility         = "${var.facility}"
  operating_system = "${var.operating_system}"
  billing_cycle    = "${var.billing_cycle}"
  project_id       = "${var.packet_project_id}"
  tags             = ["cluster-${var.cluster_name}", "etcd"]
}

resource "packet_device" "k8s_node" {
  depends_on = ["packet_ssh_key.k8s"]

  count            = "${var.number_of_k8s_nodes}"
  hostname         = "${var.cluster_name}-k8s-node-${count.index+1}"
  plan             = "${var.plan_k8s_nodes}"
  facility         = "${var.facility}"
  operating_system = "${var.operating_system}"
  billing_cycle    = "${var.billing_cycle}"
  project_id       = "${var.packet_project_id}"
  tags             = ["cluster-${var.cluster_name}", "k8s-cluster", "kube-node"]
}

resource "packet_bgp_session" "k8s_node" {
    count          = "${var.use_bgp * var.number_of_k8s_nodes}"
    device_id      = "${element(packet_device.k8s_node.*.id, count.index)}"
    address_family = "ipv4"
}

# IP blocks

resource "packet_reserved_ip_block" "metallb_addr" {
    project_id = "${var.packet_project_id}"
    facility = "${var.facility}"
    quantity = "${var.size_ip_block}"
}
