
#package
default[:ak_tools][:apt_packages] += %w[
mysql-server
php5-cli
php5-mysql
php5-mcrypt
php5-curl
php5-gd
php5-fpm
nginx
phpmyadmin
]


#linux config
default[:webserver][:unix_user]         = "vagrant"

#Mysql configuration
default[:mysql][:root_password]         = "admin25"
default[:mysql][:db][:host]             = "localhost"
default[:mysql][:db][:username]         = "mysql"
default[:mysql][:db][:password]         = "admin25"

#phpmyadmin
default[:phpmyadmin][:port]             = 8200
