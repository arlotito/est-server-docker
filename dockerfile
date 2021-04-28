FROM golang:1.14

RUN go get -d -v github.com/arlotito/est
RUN go get github.com/globalsign/pemfile
RUN go get github.com/globalsign/tpmkeys
RUN go get github.com/ThalesIgnite/crypto11
RUN go install -v github.com/arlotito/est/cmd/estserver
RUN go install -v github.com/arlotito/est/cmd/estclient

CMD ["/go/bin/estserver"]
