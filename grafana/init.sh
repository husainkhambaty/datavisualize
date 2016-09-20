#!/bin/bash
set -e

STAMP="/.grafana-setup-complete"

if [ -f ${STAMP} ]; then
  echo "grafana already configured, nothing to do."
  exit 0
fi

# TODO: Refer http://docs.grafana.org/reference/http_api/ for Grafana API

/etc/init.d/grafana-server start

until nc localhost 3000 < /dev/null; do sleep 1; done

# create influxdb datasource
curl 'http://admin:admin@localhost:3000/api/datasources' \
    -X POST -H "Content-Type: application/json" \
    --data-binary <<DATASOURCE \
      '{
        "name":"influx",
        "type":"influxdb",
        "url":"http://localhost:8086",
        "access":"proxy",
        "isDefault":true,
        "database":"testdb",
        "user":"n/a","password":"n/a"
      }'
DATASOURCE
echo

# create extra user for light theme
curl 'http://admin:admin@localhost:3000/api/admin/users' \
    -X POST -H "Content-Type: application/json" \
    --data-binary <<DATASOURCE \
      '{
        "name":"light",
        "user":"light",
        "password":"light",
        "email":"light"
      }'
DATASOURCE
echo

# set light theme for light user
curl 'http://admin:admin@localhost:3000/api/users/2' \
    -X PUT -H "Content-Type: application/json" \
    --data-binary <<DATASOURCE \
      '{
        "name":"light",
        "user":"light",
        "password":"light",
        "email":"light",
        "theme":"light"
      }'
DATASOURCE
echo

# Update the Current organization name
curl 'http://admin:admin@localhost:3000/api/org' \
    -X PUT -H "Content-Type: application/json" \
    --data-binary <<DATASOURCE \
      '{
        "name":"Planit"
      }'
DATASOURCE
echo

# Make the user an admin user
curl 'http://admin:admin@localhost:3000/api/org/users/2' \
    -X PATCH -H "Content-Type: application/json" \
    --data-binary <<DATASOURCE \
      '{
        "role":"Admin"
      }'
DATASOURCE
echo


/etc/init.d/grafana-server stop

touch ${STAMP}
