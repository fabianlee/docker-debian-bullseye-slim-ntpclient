FROM debian:bullseye-20210511

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8

RUN apt-get update \
  && apt-get install -q -y -o Dpkg::Options::="--force-confnew" chrony ntpdate ca-certificates curl \
  && rm -rf /var/lib/apt/lists/* \
  && update-ca-certificates

# start
CMD [ "bash" ]



