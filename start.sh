#!/bin/bash

set -e

# Start varnish and NCSA log
exec /usr/bin/supervisord -n
