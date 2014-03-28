#
# Cookbook Name:: bizzns-appserver
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


application "hello-world" do
  path "/srv/node-hello-world"
  owner "www-data"
  group "www-data"
  packages ["git"]

  repository "git@gitlab.com:mkaliyur/bizzns-server.git"
  revision   "develop" 

  nodejs do
    entry_point "local"
  end
end