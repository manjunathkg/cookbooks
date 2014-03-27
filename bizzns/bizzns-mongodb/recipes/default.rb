#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

 




#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2011, edelight GmbH
# Authors:
#       Markus Korn <markus.korn@edelight.de>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package node[:mongodb][:package_name] do
  action :install
  version node[:mongodb][:package_version]
end


# Create keyFile if specified
if node[:mongodb][:key_file]
  file "/etc/mongodb.key" do
    owner node[:mongodb][:user]
    group node[:mongodb][:group]
    mode  "0600"
    backup false
    content node[:mongodb][:key_file]
  end
end



## removed replica set logic - was failing version chk

  bizzns_mongodb_instance node['mongodb']['instance_name'] do
    mongodb_type 	"mongod"
    port          	node['mongodb']['config']['port']
    bind_ip     	node['mongodb']['config']['bind_ip']
    logpath         node['mongodb']['logpath']
    dbpath          node['mongodb']['config']['dbpath']
    enable_rest     node['mongodb']['config']['enable_rest']
    smallfiles      node['mongodb']['config']['smallfiles']
  end



service "mongodb" do
  supports :status => true, :restart => true
  action [:disable, :stop]
end







