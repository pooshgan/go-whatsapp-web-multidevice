# static.Dockerfile
# فقط برای بیلد استاتیک — بدون مرحله دوم
FROM golang:1.24-alpine3.20 AS builder

# ابزارهای لازم برای CGO + SQLite + استاتیک
RUN apk update && apk add --no-cache gcc musl-dev

WORKDIR /whatsapp
COPY ./src .

# دانلود وابستگی‌ها
RUN go mod download

# بیلد کاملاً استاتیک با musl
RUN CGO_ENABLED=1 GOOS=linux GOARCH=amd64 \
    go build \
    -a \
    -ldflags="-w -s -extldflags '-static'" \
    -o /app/whatsapp
