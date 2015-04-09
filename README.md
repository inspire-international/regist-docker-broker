# regist-docker-broker
The naming server of Nextra called Broker can keep track the applications' location info and provide the location info to the consumers whenever demanded.

This docker image registers its location information to Broker at start-up so that Broker can tell the whereabouts of the docker at request.

# About this package
This package includes broker and its utility broklist.

# Prerequisite
OS: Linux. We tested on AWS: amzn1.x86_64

Software: Docker

glibc >= 2.14 on which you run broker/broklist.

> How to upgrade glibc to 2.14 is well described at http://kakakikikeke.blogspot.jp/2014/10/centosdrone.html

# Preparation
### Open Docker file
Open Docker file and change Docker image which you download from Docker Hub if you like. In order to this Docker file successfully build without change, we recommend you to download centos6.x from Docker Hub. 

### Build your docker image
* Open build.sh and change image name to be built if you prefer.

* $./build.sh

### Modify environment variables in the following file suit in your environment. This file is used by the docker repository at start up.
$vi /etc/default/regist-docker-broker
> BROKERHOST=localhost

> BROKERPORT=9001

> SERVERHOST=localhost

> SERVERNAME=docker

> SERVERPORT=1936

If you run the docker on AWS and want to have the private host name to be registered, you can specify SERVERHOST as following:

```sh
SERVERHOST=`curl -s http://169.254.169.254/latest/meta-data/local-hostname`
```

# Test Drive
### Start broker on your local host
$./bin/broker -e ./env/broker.env

### Run the docker repository
* Open run.sh and change the repository name as necessary.

* $./run.sh

### Check if the docker image has been registered to the Broker
$./bin/broklist localhost 9001

# Misc
### Logging into the docker image
$ssh root@localhost -p 1936

 * password is the same as the login name.

### Stop the docker container
$sudo docker ps

$sudo docker stop  CONTAINER ID

[Nextra](http://www.inspire-intl.com/product/product_nextra.html)

#### Copyright (C) 1998 - 2015  Inspire International Inc.
