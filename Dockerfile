
FROM alpine/git as gitclone

WORKDIR /src

RUN git clone --depth 1 --branch release3.2 https://github.com/CodisLabs/codis.git

FROM golang:1.8

RUN apt-get update
RUN apt-get install -y autoconf
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

ENV GOPATH /gopath
ENV CODIS  ${GOPATH}/src/github.com/CodisLabs/codis
ENV PATH   ${GOPATH}/bin:${PATH}:${CODIS}/bin

COPY --from=gitclone /src/codis/ ${CODIS}

RUN ls -lah ${CODIS}

RUN make -C ${CODIS} distclean
RUN make -C ${CODIS} build-all

WORKDIR /codis