include_recipe "ak-tools::server"

directory "/var/www" do
  group node[:magento][:unix_user]
  owner node[:magento][:unix_user]
  mode "0755"
  action :create
end

execute "assign-root-password" do
  command "/usr/bin/mysqladmin -u root password #{node[:lamp][:mysql_root_password]}"
  action :run
  only_if "/usr/bin/mysql -u root -e 'show databases;'"
end

#Create mysql user
execute "mysql-install-mage-privileges" do
  command "/usr/bin/mysql -u root -p#{node[:lamp][:mysql_root_password]} -Dmysql -e \"GRANT ALL ON #{node[:magento][:db][:database]}. * TO '#{node[:magento][:db][:username]}'@'localhost' IDENTIFIED BY '#{node[:magento][:db][:password]}'; FLUSH PRIVILEGES;\" " 
  action :run
end

#Install fastcgi for nginx
cookbook_file "/etc/init.d/php-fastcgi" do
  source "php-fastcgi"
  owner 'root'
  group 'root'
  mode 0755
  action :create_if_missing
  notifies :restart, "service[php-fastcgi]"
end

service "php-fastcgi" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end


#Configure NGINX for PhpMyAdmin
template "/etc/nginx/sites-available/phpmyadmin" do
  owner "root"
  group "root"
  mode 00777
  source "phpmyadmin.erb"
  variables :port => node[:phpmyadmin][:port]
  notifies :restart, "service[nginx]"
end

execute "enable phpmyadmin website" do
  command "ln -s ../sites-available/phpmyadmin phpmyadmin"
  cwd "/etc/nginx/sites-enabled"
  group "root"
  user "root"
  action :run
  not_if {File.exist?("/etc/nginx/sites-enabled/phpmyadmin")}
  notifies :restart, "service[nginx]"
end

service "nginx" do
  action [ :nothing ]
end


