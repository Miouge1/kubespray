# For CI we are not worries about data persistence across reboot
$libvirt_volume_cache = "unsafe"

# Checking for box update can trigger API rate limiting
# https://www.vagrantup.com/docs/vagrant-cloud/request-limits.html
$box_check_update = false

$num_instances = 16
$vm_memory ||= 1600
$os = "ubuntu1804"
$network_plugin = "weave"
$kube_master_instances = 1
$etcd_instances = 1
$playbook = "tests/cloud_playbooks/wait-for-ssh.yml"
