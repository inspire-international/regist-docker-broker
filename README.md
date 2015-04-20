# regist-docker-broker
The naming server of Nextra called Broker can keep track the service location info and provide the location info to the consumers on demand.

This docker image registers its location information to Broker at start-up so that Broker can tell the whereabouts of the docker at request.

Additionally, service names along with their associated external/internal port numbers can be registered to Broker at Docker start-up.

![Docker location discovery](http://www.inspire-intl.com/images/dockerLocationDiscovery_en.jpg)

#Demonstration on YouTube

[![Demonstration on YouTube](http://img.youtube.com/vi/DxtPGHob29M/0.jpg)](http://www.youtube.com/watch?v=DxtPGHob29M)

# About this package
This package includes broker, its utility broklist, Dockerfile and supervisord.conf.

# Prerequisite
OS: Linux. We tested on AWS: amzn1.x86_64

Software: Docker

glibc >= 2.14 on which you run broker/broklist.

> How to upgrade glibc to 2.14 is well described at http://kakakikikeke.blogspot.jp/2014/10/centosdrone.html

# Preparation
### 2 Linux host machines
You can run Docker image and broker on the same host machine. Yet, we recommend 2 Linux host machines and explain here as we have 2 Linux host machines; running broker on 1 host machine (hostA) and Docker image on another host machine (hostB).

### Get this clone
Run git command with clone option on both machines.

$git clone https://github.com/inspire-international/regist-docker-broker.git

### Open Dockerfile on hostB
Open Dockerfile on hostB and change Docker image name if you prefer other than the default image (blalor/centos) specified in this Dockerfile. We recommend you to choose centos6.x if you select other than the default image. We here move on with no change in the Dockerfile.

### Build your docker image on hostB
* $cd regist-docker-broker
* Open build.sh on hostB and change your image name to be built if you prefer.
* $chmod +x build.sh
* $./build.sh

### Copy the following file to /tmp and modify environment variables in the file suit in your environment on hostB. This file is used by the Docker repository at start up.
$cp ./env/regist-docker-broker /tmp

$vi /tmp/regist-docker-broker
> BROKERHOST=Hostname or IP Address where broker is running.

> BROKERPORT=Port number where broker is running at.

> SERVERHOST=Hostname or IP Address where docker would run.

> SERVERNAME=Name of Docker, service names or service names with port numbers. See the example below.

> SERVERPORT=Port of Docker. Can be any port number.

Example

> BROKERHOST=10.160.121.153

> BROKERPORT=9001

> SERVERHOST=10.120.22.161

> SERVERNAME=srv1:1234/srv2:2345/srv3:3456

> SERVERPORT=1936

If you run the docker on AWS and want to have the private host name to be registered, you can specify SERVERHOST as following:

```sh
SERVERHOST=`curl -s http://169.254.169.254/latest/meta-data/local-hostname`
```
# Test Drive
### Start broker on hostA
$cd regist-docker-broker/

$chmod +x ./bin/*

$./bin/broker -e ./env/broker.env -bg

### Run the Docker repository on hostB
* Open run.sh and change the repository name as necessary.
* $chmod +x run.sh
* $./run.sh

### Check if the Docker image has been registered to the Broker on hostA
$./bin/broklist localhost 9001

```sh
srv1:1234/srv2:2345/srv3:3456 ip-10-120-22-161.ap-northeast-1.compute.internal   1936    10.120.22.161     0
```

# Misc
### Logging into the Docker image on hostB
$ssh root@localhost -p 1936

 * password is the same as the login name.

### Stop the docker container on hostB
$sudo docker ps

$sudo docker stop  CONTAINER ID

[Nextra](http://www.inspire-intl.com/product/product_nextra.html)

#### Copyright (C) 1998 - 2015  Inspire International Inc.
