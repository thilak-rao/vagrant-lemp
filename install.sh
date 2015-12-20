export DEBIAN_FRONTEND=noninteractive;

sudo apt-get install -y software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb [arch=amd64,i386] http://ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb/repo/10.1/ubuntu trusty main'
echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/nginx-stable.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C

# Download and Install the Latest Updates for the OS
#sudo apt-get update && sudo apt-get upgrade -y

# Set the Server Timezone to CST
sudo echo "Asia/Kolkata" > /etc/timezone

# Enable Ubuntu Firewall and allow SSH & MySQL Ports
sudo ufw enable
sudo ufw allow 3306 # MySQL Port
sudo ufw allow 50683/tcp # SSH Port
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

sudo apt-get install -y zsh htop git-core language-pack-UTF-8
sudo locale-gen en_US en_US.UTF-8
sudo dpkg-reconfigure locales

 # Install MariaDB
sudo debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password password PASS'
sudo debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password_again password PASS'
sudo apt-get install -y mariadb-server php5-mysql nginx php5-fpm

mysql -u root -p PASS -e "SET PASSWORD = PASSWORD('$MYSQLROOTPWD');"
sudo echo -e "cgi.fix_pathinfo=0" >> /etc/php5/fpm/php.ini

sudo mkdir -p /var/www/vagrantlemp.dev/html
sudo chown -R $USERNAME:$USERNAME /var/www/vagrantlemp.dev/html
sudo chmod -R 755 /var/www

sudo rm /etc/nginx/sites-available/default
sudo cat >> /etc/nginx/sites-available/no-default <<'EOF'
server {
  listen 80 default_server;
  return 444;
}
EOF

sudo cat >> /etc/nginx/sites-available/vagrantlemp.dev <<'EOF'
# Choose between www and non-www, listen on the *wrong* one and redirect to
# the right one -- http://wiki.nginx.org/Pitfalls#Server_Name
#
server {
  listen [::]:80;
  listen 80;

  # listen on both hosts
  server_name vagrantlemp.dev www.vagrantlemp.dev;

  # and redirect to the https host (declared below)
  # avoiding http://www -> https://www -> https:// chain.
  return 301 https://vagrantlemp.dev$request_uri;
}

server {
  listen [::]:443;
  listen 443;

  # listen on the wrong host
  server_name www.vagrantlemp.dev;

	ssl_protocols              TLSv1.2 TLSv1.1 TLSv1 SSLv3;
	ssl_ciphers                'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-DES-CBC3-SHA:ECDHE-ECDSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
	ssl_prefer_server_ciphers  on;

	ssl_session_cache    shared:SSL:10m; # a 1mb cache can hold about 4000 sessions, so we can hold 40000 sessions
	ssl_session_timeout  24h;

	# Use a higher keepalive timeout to reduce the need for repeated handshakes
	keepalive_timeout 300; # up from 75 secs default

	ssl_certificate      /etc/nginx/ssl/vagrantlemp.dev.crt;
	ssl_certificate_key  /etc/nginx/ssl/vagrantlemp.dev.key;

	ssl_stapling on;
	ssl_stapling_verify on;
	resolver 8.8.8.8 8.8.4.4 216.146.35.35 216.146.36.36 valid=60s;
	resolver_timeout 2s;

  # and redirect to the non-www host (declared below)
  return 301 https://vagrantlemp.dev$request_uri;
}

server {
  listen [::]:443 ssl spdy;
  listen 443 ssl spdy;

  # The host name to respond to
  server_name vagrantlemp.dev;
  index index.php index.html index.htm;

  ssl_protocols              TLSv1.2 TLSv1.1 TLSv1 SSLv3;
  ssl_ciphers                'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-DES-CBC3-SHA:ECDHE-ECDSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
	ssl_prefer_server_ciphers  on;

	ssl_session_cache    shared:SSL:10m; # a 1mb cache can hold about 4000 sessions, so we can hold 40000 sessions
	ssl_session_timeout  24h;

	# Use a higher keepalive timeout to reduce the need for repeated handshakes
	keepalive_timeout 300; # up from 75 secs default

	ssl_certificate      /etc/nginx/ssl/vagrantlemp.dev.crt;
	ssl_certificate_key  /etc/nginx/ssl/vagrantlemp.dev.key;

	ssl_stapling on;
	ssl_stapling_verify on;
	resolver 8.8.8.8 8.8.4.4 216.146.35.35 216.146.36.36 valid=60s;
	resolver_timeout 2s;

  location / {
    try_files $uri $uri/ /index.html;
  }

  location ~ \.php$ {
    try_files $uri =404;
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    
  }
  # Path for static files
  root /var/www/vagrantlemp.dev/html;


  #Specify a charset
  charset utf-8;

  # Custom 404 page
  error_page 404 /404.html;

  # Add trailing slash to */wp-admin requests.
  rewrite /wp-admin$ $scheme://$host$uri/ permanent;

  # Force the latest IE version
  add_header "X-UA-Compatible" "IE=Edge";

  location = /robots.txt {
    allow all;
    log_not_found off;
    access_log off;
  }
  
  location = /favicon.ico {
    log_not_found off;
    access_log off;
  }

  # cache.appcache, your document html and data
  location ~* \.(?:manifest|appcache|html?|xml|json)$ {
    expires -1;
    access_log /etc/nginx/logs/static.log;
  }

  # Feed
  location ~* \.(?:rss|atom)$ {
    expires 1h;
    add_header Cache-Control "public";
  }

  # Media: images, icons, video, audio, HTC
  location ~* \.(?:jpg|jpeg|gif|png|ico|cur|gz|svg|svgz|mp4|ogg|ogv|webm|htc)$ {
    expires 1M;
    access_log off;
    add_header Cache-Control "public";
  }

  # CSS and Javascript
  location ~* \.(?:css|js)$ {
    expires 1y;
    access_log off;
    add_header Cache-Control "public";
  }

  location ~* \.(?:ttf|ttc|otf|eot|woff|woff2)$ {
   expires 1M;
   access_log off;
   add_header Cache-Control "public";
  }

  # Prevent clients from accessing hidden files (starting with a dot)
  # This is particularly important if you store .htpasswd files in the site hierarchy
  # Access to `/.well-known/` is allowed.
  # https://www.mnot.net/blog/2010/04/07/well-known
  # https://tools.ietf.org/html/rfc5785
  location ~* /\.(?!well-known\/) {
      deny all;
  }

  # Prevent clients from accessing to backup/config/source files
  location ~* (?:\.(?:bak|conf|uploads|files|dist|fla|in[ci]|log|psd|sh|sql|sw[op])|~)$ {
      deny all;
  }
}
EOF

# Make room for some log files. 
sudo mkdir -p /etc/nginx/logs/static
sudo touch /etc/nginx/logs/static.log

# Generate SSL certificates
sudo mkdir -p /etc/nginx/ssl
sudo chown -R root:root /etc/nginx/ssl
sudo chmod -R 600 /etc/nginx/ssl

sudo openssl genrsa -out "/etc/nginx/ssl/vagrantlemp.dev.key" 2048
sudo openssl req -new -key "/etc/nginx/ssl/vagrantlemp.dev.key" -out "/etc/nginx/ssl/vagrantlemp.dev.csr" -subj "/C=IN/ST=Thilak Rao/L=Bangalore/O=Open Source/OU=Open Source/CN=vagrantlemp.dev"
sudo openssl x509 -req -days 365 -in "/etc/nginx/ssl/vagrantlemp.dev.csr" -signkey "/etc/nginx/ssl/vagrantlemp.dev.key" -out "/etc/nginx/ssl/vagrantlemp.dev.crt"


# Enable Server Block
sudo ln -s /etc/nginx/sites-available/vagrantlemp.dev /etc/nginx/sites-enabled/

# Restart Nginx
sudo service nginx restart