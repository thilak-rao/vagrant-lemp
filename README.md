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

# Provisioning File: ./bootstrap.sh
# Password for everything: vagrant
````
