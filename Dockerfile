FROM blalor/centos
MAINTAINER Norio ISHIZAKI <norio@inspire-intl.jp>

# https://docs.docker.com/examples/running_ssh_service/
RUN yum install -y passwd openssh-server initscripts wget

RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN wget http://peak.telecommunity.com/dist/ez_setup.py;python ez_setup.py;easy_install distribute;
RUN wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py;python get-pip.py;
RUN pip install supervisor

# Install regist-docker-broker 
RUN wget http://www.inspire-intl.com/product/nextra/download/docker/regist-docker-broker -O /etc/rc.d/init.d/regist-docker-broker
RUN chmod +x /etc/rc.d/init.d/regist-docker-broker 

# Install broker
RUN wget http://www.inspire-intl.com/product/nextra/download/docker/broker -O /usr/local/bin/broker
RUN chmod +x /usr/local/bin/broker

# Install broklist
RUN wget http://www.inspire-intl.com/product/nextra/download/docker/broklist -O /usr/local/bin/broklist
RUN chmod +x /usr/local/bin/broklist

# Install libc-2.14.1.so
RUN wget http://www.inspire-intl.com/product/nextra/download/docker/libc-2.14.1.so -O /lib64/libc-2.14.1.so
RUN chmod +x /lib64/libc-2.14.1.so
RUN cd /lib64 && ln -nfs libc-2.14.1.so libc.so.6

EXPOSE 22

ADD supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord"]
