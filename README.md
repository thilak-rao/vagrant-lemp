Ubuntu 14.04 LTS with LEMP Provisioning
-------------
This vagrant setup mirrors my DigitalOcean droplets. I use this as a starter for my personal projects.

### Prerequisites
**You need VirtualBox and Vagrant to be installed in your computer**
*	Download [VirtualBox](https://www.virtualbox.org/wiki/Downloads). 
*	Download [Vagrant](https://www.vagrantup.com/downloads.html)

### Installation
```` 
git clone https://github.com/xthilakx/vagrant-lemp.git
vagrant plugin install vagrant-hostsupdater
vagrant up
````

#### VM Details
````
# Hostname: vagrantlemp.dev
# SSH Port: 50683
# Port 80 (Guest) > Port 80 (Host)
# Port 50683 (Guest) > Port 50683 (Host)

# Provisioning: ./install.sh
# ./always.sh runs after every boot. 
# Password for everything: vagrant
````

##### Bypassing Browser SSL warnings
OS X users can bypass this warning by adding ./data/certificate/vagrantlemp.dev.crt to Keychain Access. 

##### Known Issues
*	Hostname is hard coded to vagrantlemp.dev in nginx server blocks. Use search and replace as a workaround. Defect: [#1](https://github.com/xthilakx/vagrant-lemp/issues/1) Pull requests are always appreciated.