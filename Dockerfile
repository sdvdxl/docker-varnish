FROM centos:6.4

RUN rpm --nosignature -i http://repo.varnish-cache.org/redhat/varnish-3.0/el6/noarch/varnish-release/varnish-release-3.0-1.el6.noarch.rpm

RUN yum install -y varnish

ADD default.vcl /etc/varnish/default.vcl

ENV VARNISH_PORT 80

# Expose port 80
EXPOSE 80

ADD start /start
RUN chmod 0755 /start
CMD ["/start"]
