## Requisitos

**VirtualBox**: 7.0.6, ExtensionPack 7.0.6/7.0.12  
**Vagrant**: 2.3.4  
**Vagrant plugins**: vagrant-hostmanager, vagrant-vbguest  
**Packer**: 1.10.2

````
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-vbguest
packer plugins install github.com/hashicorp/vagrant
````

**Box generic/rocky8**: 4.1.20  
````powershell
vagrant box add --name generic/rocky8 https://app.vagrantup.com/generic/boxes/rocky8/versions/4.1.20/providers/virtualbox/unknown/vagrant.box
````
O especificar la versión en el vagrantfile
````rb
Vagrant.configure("2") do |config|
  config.vm.box = "generic/rocky8"
  config.vm.box_version = "4.1.20"
end
````
Versiones posteriores no debería dar problemas.

Para usar la box personalizada:
````powershell
packer build -force template.pkr.hcl
vagrant box add --name NOMBRE directorio/salida/package.box
````

Modificar el /etc/hosts y asignarle lo siguiente
````bash
192.168.56.40 grafana.idctfg.k8s.es
192.168.56.40 prometheus.idctfg.k8s.es
````
O los nombre de deminio que se especifiquen en **provisioning/manifests/kube-ingress.yaml**
## Ejecución

````
vagrant up --provision-with shell
vagrant provision --provision-with ansible_local
````
