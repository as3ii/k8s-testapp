# k8s-testapp
This is a simple application to test my kubernetes cluster.

This simple program listen on port 8080 exposing a simple REST interface:
- `/health`
  - `GET`: just return 200, with body `{"status": "ok", "pod": "$HOSTNAME"}`
- `/data`
  - `GET`: get last 100 records
  - `POST`: requires json-encoded `message` parameter, adds the message in DB
- `/record`
  - `GET`: requires `id` parameter, returns the record with the given id
  - `DELETE`: requires `id` parameter, delete the record with the given id

Note: `main.go` was partially written with LLMs

## Required environment variables
This app requires the following environment variables to connect to a postgres DB:
- DB_USER
- DB_PASSWORD
- DB_NAME
- DB_HOST
- DB_PORT

## Deploy on k8s
The folder `./k8s/simple` contains the charts for a kubernetes deployment.
Starts editing `config.yaml` to set a strong and secure password for the database
and then edit `gateway.yaml` to set the domain name and tls secret (if you are
not using cert-manager), alternatively you can write your own ingress definition.
Next create the namespace via `kubectl apply -f ./k8s/simple/namespace.yaml`, and
after that you can apply the other files (or the entire folder)
