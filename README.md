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

Partially written with LLMs

## Required environment variables
This app requires the following environment variables to connect to a postgres DB:
- DB_USER
- DB_PASSWORD
- DB_NAME
- DB_HOST
- DB_PORT
