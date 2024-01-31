source "vagrant" "tfg_rocky8" {
  communicator = "ssh"
  source_path  = "generic/rocky8"
  box_version  = "2.0.0"
  provider     = "virtualbox"
  add_force    = true
  skip_add     = true
  template     = "provisioning/Vagrantfile.template"
}

build {
  sources = ["source.vagrant.tfg_rocky8"]

  provisioner "shell" {
    script  = "provisioning/prov_packer.sh"
    timeout = "30m"
  }
}