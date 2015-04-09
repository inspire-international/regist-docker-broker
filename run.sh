#!/bin/sh
sudo docker run -d -v /etc/default/regist-docker-broker:/etc/default/regist-docker-broker -p 1936:22 broklist/centos6.5:0.1
