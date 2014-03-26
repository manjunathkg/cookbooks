#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


include_recipe 'nginx::commons_dir'



template 'index.html' do
  path   "#{node['nginx']['default_root']}/index.html"
  source 'default.erb'
  owner  "#{node['nginx']['user']}"
  group  "#{node['nginx']['user']}"
  mode   '0755'
  notifies :reload, 'service[nginx]'
end

