FROM centos:centos6
MAINTAINER Paul Lewis <paullewis91@gmail.com>

RUN rpm --nosignature -i http://repo.varnish-cache.org/redhat/varnish-3.0/el6/noarch/varnish-release/varnish-release-3.0-1.el6.noarch.rpm http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum install -y wget git tar unzip varnish varnish-libs-devel supervisor libcurl libcurl-devel rrdtool rrdtool-devel perl-devel libgcrypt-devel gcc make gcc-c++ pcre-devel ncurses-devel libedit-devel python-docutils libtool rpm-build libxslt geoip geoip-devel

# Varnish Source
RUN rpm --nosignature -i http://repo.varnish-cache.org/redhat/varnish-3.0/el6/src/varnish/varnish-3.0.5-1.el6.src.rpm
RUN rpmbuild -bc /rpmbuild/SPECS/varnish.spec

# Autoconf
RUN curl -L http://ftpmirror.gnu.org/autoconf/autoconf-2.69.tar.gz | tar xz
RUN cd autoconf-2.69 && ./configure --prefix=/usr && make && make install

# Var vmod https://github.com/varnish/libvmod-var
RUN cd && wget -q https://github.com/varnish/libvmod-var/archive/3.0.zip -O libvmod-var.zip && unzip libvmod-var.zip
RUN cd libvmod-var-3.0 && ./autogen.sh && ./configure VARNISHSRC=/rpmbuild/BUILD/varnish-3.0.5/ VMODDIR=/usr/lib64/varnish/vmods && make && make install

# Var vmod https://github.com/varnish/libvmod-header
RUN cd && wget -q https://github.com/varnish/libvmod-header/archive/3.0.zip -O libvmod-header.zip && unzip libvmod-header.zip
RUN cd libvmod-header-3.0 && ./autogen.sh && ./configure VARNISHSRC=/rpmbuild/BUILD/varnish-3.0.5/ VMODDIR=/usr/lib64/varnish/vmods && make && make install

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
