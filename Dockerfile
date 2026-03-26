FROM golang:1.26-alpine AS builder
WORKDIR /app 
COPY . . 

RUN CGO_ENABLED=0 go build -o gatus 

FROM scratch
WORKDIR /app 

COPY --from=builder /app/config/config.yaml /app/config/config.yaml 
COPY --from=builder /app/gatus /app/gatus 
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

EXPOSE 8080


 CMD ["/app/gatus"]