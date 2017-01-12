FROM ubuntu:14.04
MAINTAINER Fezzpu 

RUN mkdir -p /opt/workspace 
ENV GOPATH /opt/workspace
ENV DEBIAN_FRONTEND noninteractive


# setup our Ubuntu sources (ADD breaks caching)
#RUN echo "deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu precise main\n\
#">> /etc/apt/sources.list

#RUN echo "Acquire::http { Proxy \"http://172.17.42.1:3142\"; };\n\
#Acquire::http::Proxy {\n\
#    private-ppa.launchpad.net DIRECT;\n\
#    download.virtualbox.org DIRECT;\n\
#}\n\
#" > /etc/apt/apt.conf.d/90apt-cacher-ng

# no Upstart or DBus
# https://github.com/dotcloud/docker/issues/1724#issuecomment-26294856
#RUN apt-mark hold initscripts udev plymouth mountall
#RUN dpkg-divert --local --rename --add /sbin/initctl && ln -fs /bin/true /sbin/initctl
COPY sources.list /etc/apt/
COPY resolv.conf /etc/
RUN apt-get update
RUN apt-get -f install

#RUN apt-get install -y  git
#RUN apt-get install -y golang
RUN apt-get install -y net-tools 
RUN apt-get install -y inetutils-ping
RUN apt-get install -y pptpd

# install our "base" environment
RUN apt-get install -y --no-install-recommends openssh-server pwgen sudo vim-tiny

## install tty.js
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7917B12
#RUN apt-get install -y --force-yes nodejs
#ADD tty.js /tty.js/

# clean up after ourselves
RUN apt-get clean
#RUN rm /etc/apt/apt.conf.d/90apt-cacher-ng
COPY pptpd-options /etc/ppp/pptpd-options
COPY chap-secrets /etc/ppp/chap-secrets
COPY pptpd.conf /etc/pptpd.conf
ADD startup.sh /
EXPOSE 1723
#EXPOSE 3000
WORKDIR /
ENTRYPOINT ["/startup.sh"]