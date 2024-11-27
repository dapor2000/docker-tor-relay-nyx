FROM alpine:latest
LABEL maintainer="dapor <tor-relay@dapor.de>"

ENV RELAY_NICKNAME=ChangeMe
ENV RELAY_TYPE=middle
ENV RELAY_BANDWIDTH_RATE="100 KBytes"
ENV RELAY_BANDWIDTH_BURST="200 KBytes"
ENV RELAY_ORPORT=9001
ENV RELAY_DIRPORT=9030
ENV RELAY_CTRLPORT=9051
ENV RELAY_ACCOUNTING_MAX="1 GBytes"
ENV RELAY_ACCOUNTING_START="day 00:00"
ENV RELAY_MAX_MEM="512 MB"

# add group/user tor with ID
RUN addgroup -g 1000 -S tor && \
    adduser -u 1000 -S tor -G tor

RUN apk --no-cache add \
	bash \
	tor \
    nyx \
    htop

# copy in our torrc files
COPY torrc.bridge /etc/tor/torrc.bridge
COPY torrc.middle /etc/tor/torrc.middle
COPY torrc.exit /etc/tor/torrc.exit

# copy the run script
COPY run.sh /run.sh
RUN chmod ugo+rx /run.sh

EXPOSE 9001

# make sure files are owned by tor user
RUN chown -R tor /etc/tor

USER tor


VOLUME ["/var/lib/tor"]
RUN chown -R tor /var/lib/tor

ENTRYPOINT [ "/run.sh" ]


