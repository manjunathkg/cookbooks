#
# Cookbook Name:: bizzns-appserver
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
 

application "bizzns-server" do
  path "#{node['bizzns-server']['deployment']['location']}"
  owner "#{ node['bizzns-server']['deployment']['owner'] }"
  group "#{ node['bizzns-server']['deployment']['group'] }"
  packages ["git"]

  repository "#{ node['bizzns-server']['deployment']['giturl']  }"

  nodejs do
    entry_point "#{ node['bizzns-server']['deployment']['application_entrypoint_js'] }"
  end
end


 