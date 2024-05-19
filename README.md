## Requierements and Additional configuration

**VirtualBox**: 7.0.6, ExtensionPack 7.0.6 >=   
**Vagrant**: 2.3.4   
**Vagrant plugins**: vagrant-hostmanager, vagrant-vbguest  
**Packer**: 1.10.2 >=

**Newer version should work without problems**

````
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-vbguest
packer plugins install github.com/hashicorp/vagrant
````

**Box generic/rocky8**: 4.1.20  
````powershell
vagrant box add --name generic/rocky8 https://app.vagrantup.com/generic/boxes/rocky8/versions/4.1.20/providers/virtualbox/unknown/vagrant.box
````
OR
````rb
Vagrant.configure("2") do |config|
  config.vm.box = "generic/rocky8"
  config.vm.box_version = "4.1.20"
end
````

### Packer 
Add the custom box to Vagrant:
````powershell
packer build -force template.pkr.hcl
vagrant box add --name NOMBRE directorio/salida/package.box
````

### Hostname resolution
Add to /etc/hosts (C:\Windows\System32\drivers\etc) the following:
````bash
192.168.56.40 grafana.idctfg.k8s.es
192.168.56.40 prometheus.idctfg.k8s.es
````
IP address must be the one asigned to ingress-nginx-controller via metallb. Hostname  must the same as the specified in **provisioning/manifests/kube-ingress.yaml** .
## Execution

````
vagrant up --provision-with shell
vagrant provision --provision-with ansible_local
````
