FROM ubuntu
 
RUN echo 'deb http://archive.ubuntu.com/ubuntu precise main universe' > /etc/apt/sources.list && \
    echo 'deb http://archive.ubuntu.com/ubuntu precise-updates universe' >> /etc/apt/sources.list && \
    apt-get update

#Runit
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y runit 
CMD /usr/sbin/runsvdir-start

#SSHD
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server &&	mkdir -p /var/run/sshd && \
    echo 'root:root' |chpasswd

#Utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim less net-tools inetutils-ping curl git telnet nmap socat dnsutils netcat tree htop unzip sudo

#Install Oracle Java 7
RUN apt-get install -y python-software-properties && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java7-installer

RUN wget https://github.com/eBay/restsuperman/archive/master.zip && \
    unzip master.zip
RUN rm master.zip

#Configuration
ADD . /docker
#Runit
RUN chmod +x /docker/sv/ssh/run /docker/sv/ssh/log/run && ln -s /docker/sv/ssh /etc/service/
RUN chmod +x /docker/sv/commander/run /docker/sv/commander/log/run && ln -s /docker/sv/commander /etc/service/

ENV HOME /root
WORKDIR /root
EXPOSE 22
