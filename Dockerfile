FROM golang:1.24.2 AS builder

WORKDIR /app

COPY . .

RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o app .

FROM alpine:latest  

WORKDIR /app

RUN apk add --no-cache sqlite

COPY --from=builder /app/app .
COPY --from=builder /app/tracker.db .

CMD ["./app"]