# Start from the latest golang base image
FROM golang:1.19 as builder

WORKDIR /build

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the Go app - Generate heic2jpg binary
RUN CGO_ENABLED=1 go build -ldflags='-extldflags=-static' -a -o ./deploy/heic2jpg ./heic2jpg

FROM scratch
# Copy the binary from the builder stage
COPY --from=builder /build/deploy/heic2jpg /
ENTRYPOINT [ "/heic2jpg" ]
