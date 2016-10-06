FROM ubuntu:12.04
MAINTAINER Fezzpu 

RUN mkdir -p /opt/workspace 
ENV GOPATH /opt/workspace
ENV DEBIAN_FRONTEND noninteractive

RUN rm /var/lib/apt/lists/* -vf && apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y golang
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git

RUN apt-mark hold initscripts udev plymouth mountall
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -fs /bin/true /sbin/initctl

RUN apt-get update

# install our "base" environment
RUN apt-get install -y --no-install-recommends openssh-server pwgen sudo vim-tiny

# install tty.js
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7917B12
RUN apt-get install -y --force-yes nodejs
ADD tty.js /tty.js/

# clean up after ourselves
RUN apt-get clean
#RUN rm /etc/apt/apt.conf.d/90apt-cacher-ng

ADD startup.sh /
EXPOSE 22
EXPOSE 3000
WORKDIR /
ENTRYPOINT ["/startup.sh"]
