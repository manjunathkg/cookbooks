#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2014, Bizzns, Inc
#
# All rights reserved - Do Not Redistribute
#



## Stop any services /components we want to be sure not to be running on any ubuntu box




## Any services/tools we want to be running on any ubuntu box



## create any default users who needs to be on all machines

user_account 'manju' do
    ssh_keygen true
end

user_account 'versteegp' do
    ssh_keygen true
end







