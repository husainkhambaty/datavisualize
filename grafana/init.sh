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

/etc/init.d/grafana-server stop

touch ${STAMP}
