FROM debian:buster as build

RUN apt update && apt install -y git golang

ADD . /src/

WORKDIR /src

ENV GOBIN=/src/bin \
    GOPATH=/src/go \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

COPY go.mod .
COPY go.sum .

RUN go mod download

RUN go install ./...

FROM scratch

COPY --from=build /src/bin/server /server
COPY --from=build /src/bin/client /client

CMD ["/server"]
