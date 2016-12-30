#!/bin/bash
set -e
rm -rf /var/run/rsyslogd.pid
exec /usr/sbin/rsyslogd "$@"
