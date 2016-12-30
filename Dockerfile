FROM fedora:latest

# Derived from jplock/rsyslog
# Credit to original maintainer Justin Plock <justin@plock.net>
# We just add volumes and some templates to the image
MAINTAINER Daniel Whicker <dwhicker@bifrost.cc>

ENV REFRESHED_ON "30 Dec 2016"
ENV DEBIAN_FRONTEND noninteractive

RUN dnf update 
RUN dnf install -q -y rsyslog
RUN dnf -q -y upgrade 

RUN sed 's/#$ModLoad imudp/$ModLoad imudp/' -i /etc/rsyslog.conf
RUN sed 's/#$UDPServerRun 514/$UDPServerRun 514/' -i /etc/rsyslog.conf
RUN sed 's/#$ModLoad imtcp/$ModLoad imtcp/' -i /etc/rsyslog.conf
RUN sed 's/#$InputTCPServerRun 514/$InputTCPServerRun 514/' -i /etc/rsyslog.conf
RUN sed 's/$ModLoad imklog/#$ModLoad imklog/' -i /etc/rsyslog.conf
RUN sed 's/$FileOwner syslog/$FileOwner root/' -i /etc/rsyslog.conf
RUN sed 's/$PrivDropToUser syslog/#$PrivDropToUser syslog/' -i /etc/rsyslog.conf
RUN sed 's/$PrivDropToGroup syslog/#$PrivDropToGroup syslog/' -i /etc/rsyslog.conf

ADD start.sh /usr/local/bin/
ADD hostslogs.conf /etc/rsyslog.d/

EXPOSE 514/tcp 514/udp
VOLUME ["/var/log/hosts"]

ENTRYPOINT ["/usr/local/bin/start.sh"]
CMD ["-n"]
