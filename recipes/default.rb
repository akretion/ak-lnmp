include_recipe "ak-tools::server"


group node[:webserver][:unix_user] do
end
  
user node[:webserver][:unix_user] do
  comment "Default User"
  gid node[:webserver][:unix_user]
  home "/home/#{node[:webserver][:unix_user]}"
  supports :manage_home=>true
  shell "/bin/bash"
end



directory "/var/www" do
  group node[:webserver][:unix_user]
  owner node[:webserver][:unix_user]
  mode "0755"
  action :create
end

execute "assign-root-password" do
  command "/usr/bin/mysqladmin -u root password #{node[:mysql][:root_password]}"
  action :run
  only_if "/usr/bin/mysql -u root -e 'show databases;'"
end

if node[:mysql][:db][:database]
#Create mysql user
  execute "mysql-install-mage-privileges" do
    command "/usr/bin/mysql -u root -p#{node[:mysql][:root_password]} -Dmysql -e \"GRANT ALL ON #{node[:mysql][:db][:database]}. * TO '#{node[:mysql][:db][:username]}'@'localhost' IDENTIFIED BY '#{node[:mysql][:db][:password]}'; FLUSH PRIVILEGES;\" " 
    action :run
  end
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


