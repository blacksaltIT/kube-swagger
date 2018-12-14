#!/usr/bin/env bash

set -e

if [[ $MASTER_API_SWAGGER_URL = local ]]; then
    MASTER_API_SWAGGER_URL=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT_HTTPS/swaggerui
fi

api-spec-converter --from=swagger_1 $MASTER_API_SWAGGER_URL --to=swagger_2 > /www/swagger.json

if [[ "$KEEP_API_CALLS" = "false" ]]; then
    jq 'del(.tags[0:], .paths) | . + {"paths":{}}' /www/swagger.json > /www/swagger.json.nopaths
    mv /www/swagger.json.nopaths /www/swagger.json
fi

http-server /www 
