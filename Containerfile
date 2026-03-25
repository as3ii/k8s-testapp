FROM golang:1.25-alpine AS builder
WORKDIR /app
COPY src/go.mod src/go.sum ./
RUN go mod download
COPY src/* ./
RUN go build -o k8s-testapp .

FROM alpine:3.18
RUN apk add --no-cache ca-certificates
WORKDIR /root/
COPY --from=builder /app/k8s-testapp .
EXPOSE 8080
CMD ["./k8s-testapp"]
