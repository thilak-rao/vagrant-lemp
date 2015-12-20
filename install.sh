export DEBIAN_FRONTEND=noninteractive;

# Download and Install the Latest Updates for the OS
sudo apt-get update && sudo apt-get upgrade -y

# Set the Server Timezone to CST
sudo echo "Asia/Kolkata" > /etc/timezone

# Enable Ubuntu Firewall and allow SSH & MySQL Ports
sudo ufw enable
sudo ufw allow 3306 # MySQL Port
sudo ufw allow 50683/tcp # SSH Port
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

sudo apt-get install -y zsh htop git-core
sudo locale-gen en_US en_US.UTF-8
sudo dpkg-reconfigure locales

sudo apt-get install -y software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb [arch=amd64,i386] http://ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb/repo/10.1/ubuntu trusty main'
 
 # Install MariaDB
sudo debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password password $MYSQLROOTPWD'
sudo debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password_again password $MYSQLROOTPWD'
sudo apt-get install -y mariadb-server php5-mysql nginx php5-fpm
# Tested to work till here
# sudo echo "cgi.fix_pathinfo=0" >> /etc/php5/fpm/php.ini