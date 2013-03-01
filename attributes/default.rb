
#package
default[:ak_tools][:apt_packages] += %w[
mysql-server
php5-cli
php5-mysql
nginx
php5-cgi
phpmyadmin
]

#Mysql configuration
default[:lamp][:mysql_root_password]      = "admin25"

#phpmyadmin
default[:phpmyadmin][:port]               = 8200
