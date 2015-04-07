# regist-docker-broker
The naming server of Nextra called Broker can keep track the applications' location info and provide the location info to the consumers whenever demanded.

This docker image registers its location information to Broker at start-up so that Broker can tell the whereabouts of the docker at request.

# About this package
This package includes broker and its utility broklist. You need to download the docker image which contains mysql and Nextra as described in this README.

# Prerequisite
OS: Linux. We tested on AWS: amzn1.x86_64

Software: Docker

glibc >= 2.14 on which you run broker/broklist.

> How to upgrade glibc to 2.14 is well described at http://kakakikikeke.blogspot.jp/2014/10/centosdrone.html

# Preparation
### Download and unpack the docker image
$wget http://www.inspire-intl.com/product/nextra/download/broker-centos6.6-mysql_0.8.tar.gz

$gzip -d broker-centos6.6-mysql:0.8.tar.gz

### Load the docker image into the repository
$sudo docker load < broker-centos6.6-mysql:0.8.tar

### Change the tag name
$sudo docker images
> REPOSITORY  TAG IMAGE ID CREATED VIRTUAL SIZE
> <none>  <none>  116640a845cb  2 days ago  637.3 MB

$sudo docker tag 116640a845cb broker-centos6.6-mysql:0.8

### Create environment variables to be used in the docker repository at start up
$vi /etc/default/regist-docker-broker
> BROKERHOST=localhost

> BROKERPORT=9001

> SERVERHOST=localhost

> SERVERNAME=docker

> SERVERPORT=1935

If you run the docker on AWS and want to have the private host name to be registered, you can specify SERVERHOST as following:

```sh
SERVERHOST=`curl -s http://169.254.169.254/latest/meta-data/local-hostname`
```

# Test Drive
### Start broker on your local host
$./bin/broker -e ./env/broker.env

### Run the docker repository
$sudo docker run -d -v /etc/default/regist-docker-broker:/etc/default/regist-docker-broker -p 1935:22 -p 5080:3306 broker-centos6.6-mysql:0.8

### Check if the docker image has been registered to the Broker
$broklist localhost 9001

# Misc
### Logging into the docker image
$ssh root@localhost -p 1935

 * password is the same as the login name.

### Stop the docker container
$sudo docker ps

$sudo docker stop  CONTAINER ID

[Nextra](http://www.inspire-intl.com/product/product_nextra.html)

#### Copyright (C) 1998 - 2015  Inspire International Inc.
