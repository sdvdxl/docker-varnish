Docker - Varnish with NCSA Logging
====

This Docker container can be used to launch Varnishd with the Varnischncsa logger. The varnishncsa utility reads varnishd's shared memory logs and presents them in the Apache/NCSA "combined" log format.

This format can be customized in the supervisord.conf to match your preferred format so it's log volume can be mounted to other Docker containers for analysis/graphing.

## Usage

### Pulling from the Docker Index

This image is available for download on the Docker Index.

```
docker pull paul91/varnish
```

If successful, this image can be found in your local list of images through `docker ps`.

### Building the container

If you would like to customize this container, clone this repo, make your changes, and build.

```
docker build -t paul91/varnish .
```

### Starting the container

It is recommended that you either mount the container's `/var/log/varnish` directory to the host machine or another container (i.e LogStash) to fully take advantage of the NCSA logging.

```
docker run -i -t -p 80:80 -v /tmp/varnish:/var/log/varnish paul91/varnish
```

You can also mount a custom `default.vcl` using Docker volumes.
```
docker run -d -p 80:80 \
  -v $(pwd)/custom.vcl:/etc/varnish/default.vcl:ro \
  -v /tmp/varnish/:/var/log/varnish \
  paul91/varnish
```

### Available environment variables

Setting any of the following environment variables with `-e` will override the defaults set in the `Dockerfile` when Varnish is started. If you would like to add additional parameters, please open a Pull Request.

#### Varnishd

* `VARNISH_TTL`: Specifies a hard minimum time to live for cached documents. This is a shortcut for specifying the default_ttl run-time parameter. Default: 60

#### Varnishncsa

* `VARNISHNCSA_LOGFORMAT`: Specify the log format used. If no format is specified the default log format is used. Default: `%h %l %u %t "%r" %s %b "%{Referer}i" "%{User-agent}i"`

### Killing the container

All running `paul91/varnish` containers can be killed by the following command.

```bash
docker ps | grep 'paul91/varnish' | awk '{print $1}' | xargs docker kill
```

### Testing/Building with Vagrant

The `Vagrantfile` packaged with this Docker container will build a virtual machine using [CoreOS](https://coreos.com/). Information specific to this type of virtual machine can be found [here](https://github.com/coreos/coreos-vagrant).

## To Do

* Customizable environment variables (ports/logformat/etc).

## Contributing

This project accepts contributions via GitHub pull requests [here](https://github.com/paul91/docker-varnish/issues).

## License

`paul91/docker-varnish` is available under the Apache License 2.0. See LICENSE for more details.

## Reference

* [varnishd](https://www.varnish-cache.org/docs/trunk/reference/varnishd.html)
* [varnishncsa](https://www.varnish-cache.org/docs/trunk/reference/varnishncsa.html)
* [Share Directories via Volumes](http://docs.docker.io/use/working_with_volumes/)
