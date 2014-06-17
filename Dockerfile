FROM centos:6.4
MAINTAINER Paul Lewis <paullewis91@gmail.com>

RUN rpm --nosignature -i http://repo.varnish-cache.org/redhat/varnish-3.0/el6/noarch/varnish-release/varnish-release-3.0-1.el6.noarch.rpm http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum install -y varnish supervisor

# Expose port 80
EXPOSE 80
EXPOSE 6082

# Varnishd environment variables
ENV VARNISH_TTL 60

# Varnishncsa environment variables
ENV VARNISHNCSA_LOGFORMAT %h %l %u %t "%r" %s %b "%{Referer}i" "%{User-agent}i

ADD default.vcl /etc/varnish/default.vcl
ADD supervisord.conf /etc/supervisord.conf

ADD start.sh /srv/start.sh
RUN chmod 755 /srv/start.sh
CMD ["/srv/start.sh"]
