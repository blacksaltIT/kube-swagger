FROM node:9.11.1-alpine

RUN npm install -g api-spec-converter@2.7.2 http-server@0.11.1 --unsafe-perm=true --allow-root
COPY swagger-ui-3.13.6 /www
RUN apk update && \
       apk add jq && \
       rm -rf /var/cache/apk/*
RUN chmod 777 /www

ENV MASTER_API_SWAGGER_URL=required
ENV KEEP_API_CALLS=false
USER 123456789
EXPOSE 8080
CMD api-spec-converter --from=swagger_1 $MASTER_API_SWAGGER_URL --to=swagger_2 > /www/swagger.json && \
    ([ "$KEEP_API_CALLS" = "false" ] && \
       jq 'del(.tags[0:], .paths) | . + {"paths":{}}' /www/swagger.json > /www/swagger.json.nopaths && \
       mv /www/swagger.json.nopaths /www/swagger.json || true) && \
    http-server /www 