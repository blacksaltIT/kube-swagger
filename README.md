Did you ever wonder what can you write in a kuberenetes API object? What are your possibilities?

Probably yes and you searched for the kubernetes api reference page and Ctrl+F. Ah! Then you recalled some swaggerish things in OpenShift. After some googling you tried several github projects which are obsoleted today mostly because OpenShift still uses swagger 1.2.

No? Maybe, that was me.

# Getting started

## Quick try

See deployment.png in the repo or run

`docker run --rm -it -p 8080:8080 -e MASTER_API_SWAGGER_URL=https://console.starter-ca-central-1.openshift.com/swaggerapi janosroden/oc-swagger`

Then go to http://localhost:8080/

## Environment variables

- MASTER_API_SWAGGER_URL: Your OpenShift swagger endpoint, for me it's https://example.cloud:8443/swaggerapi
- KEEP_API_CALLS: `false` by default, which means the REST API paths will be removed, you can browse the object models only. Keep in mind you can't use swagger's 'Try it' feature due to the missing auth token.

## Build your own image and deploy to the cluster

`oc new-app swagger --env MASTER_API_SWAGGER_URL=https://example.cloud:8443/swaggerapi --env KEEP_API_CALLS=false https://github.com/janosroden/oc-swagger.git`

Then create a route and browse.

## Use existing dockerhub image and deploy to the cluster

`oc new-app --env MASTER_API_SWAGGER_URL=https://example.cloud:8443/swaggerapi --env KEEP_API_CALLS=false janosroden/oc-swagger`

Then create a route and browse.

## Run it locally

`docker run -d -p 8080:8080 -e KEEP_API_CALLS=false -e MASTER_API_SWAGGER_URL=https://example.cloud:8443/swaggerapi janosroden/oc-swagger`

Then go to http://localhost:8080/

# How it works?

At the start of the container [api-spec-converter](https://github.com/LucyBot-Inc/api-spec-converter) converts `$MASTER_API_SWAGGER_URL` to swagger 2.0 format. Then depending on `$KEEP_API_CALLS` it removes the REST API paths from the swagger file with [jq](https://stedolan.github.io/jq/manual/v1.5/). Finally the [http-server](https://github.com/indexzero/http-server) serves the static files.
