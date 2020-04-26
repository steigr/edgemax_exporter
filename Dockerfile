FROM golang:1.14.2 AS builder
WORKDIR /app
COPY go.mod go.mod
COPY go.sum go.sum
RUN  go mod download

ENV  GOOS=linux CGO_ENABLED=0

COPY cmd/ cmd/
COPY edgemax/ edgemax/
COPY exporter.go exporter.go
COPY dpi_collector.go dpi_collector.go
COPY interfaces_collector.go interfaces_collector.go
COPY system_collector.go system_collector.go

RUN  go build -o /bin/edgemax-exporter ./cmd/edgemax_exporter/...
RUN  strip -s /bin/edgemax-exporter

FROM alpine:3.11
COPY --from=builder /bin/edgemax-exporter /bin/edgemax-exporter
ENTRYPOINT ["edgemax-exporter"]
