#!/bin/bash
set -e

STAMP="/.influxdb-setup-complete"

if [ -f ${STAMP} ]; then
  echo "influxdb already configured, nothing to do."
  exit 0
fi

# Solve the Graphite configuration
# TODO: Accept a config param. If its true then we run the below command otherwise 
# \cp -p /etc/influxdb/influxdb.conf /etc/opt/influxdb/influxdb.conf

/etc/init.d/influxdb start 

# wait for influxdb to respond to requests
until /opt/influxdb/influx -execute 'show databases'; do sleep 1; done
/opt/influxdb/influx -execute 'create database testdb'

/etc/init.d/influxdb stop

touch ${STAMP}
