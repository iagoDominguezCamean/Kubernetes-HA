## Requisitos

**VirtualBox**: 7.0.6, ExtensionPack 7.0.6/7.0.12  
**Vagrant**: 2.3.4  
**Vagrant plugins**: vagrant-hostmanager, vagrant-vbguest  

````
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-vbguest
````

**Box generic/rocky8**: 4.1.20  
````
vagrant box add --name generic/rocky8 https://app.vagrantup.com/generic/boxes/rocky8/versions/4.1.20/providers/virtualbox/unknown/vagrant.box
````
O especificar la versión en el vagrantfile
````
Vagrant.configure("2") do |config|
  config.vm.box = "generic/rocky8"
  config.vm.box_version = "4.1.20"
end
````
Versiones posteriores no debería dar problemas.
## Ejecución

````
vagrant up --provision-with shell
vagrant provision --provision-with ansible_local
````
