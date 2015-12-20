# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant version requirements
Vagrant.require_version ">= 1.7.4"

Vagrant.configure(2) do |config|
  # For a complete reference: https://docs.vagrantup.com.

  config.vm.box = "ubuntu/trusty64" # You can search for boxes at https://atlas.hashicorp.com/search.
  config.vm.box_check_update = false
  config.vm.hostname = "vagrantlemp.dev"
  config.vm.post_up_message = "Vagrant LEMP is now setup. README.md will provide additional VM Details.\n\nHappy hacking!\nMade with love in Bangalore, India by Thilak Rao"

  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.network "forwarded_port", guest: 50683, host: 50683
  config.vm.network :private_network, ip: "192.168.33.10"
  config.vm.hostname = "vagrantlemp.dev"
  config.hostsupdater.aliases = ["www.vagrantlemp.dev"]

  # config.vm.network "public_network"
  # config.vm.synced_folder "./data", "~/host_data"

  # envi.sh contains all environment specific variables. 
  # install.sh will run on first launch
  # always.sh will run on every boot. 

  config.vm.provision "shell", path: "envi.sh", run: "always"
  config.vm.provision "shell", path: "always.sh", run: "always"
  config.vm.provision "shell", path: "install.sh"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "512"
  end
end
