FROM alpine:3.20

RUN apk add --no-cache util-linux

COPY concurrent.sh /usr/local/bin/concurrent.sh
RUN chmod +x /usr/local/bin/concurrent.sh

ENV SHARED_DIR=/shared
VOLUME ["/shared"]

CMD ["/usr/local/bin/concurrent.sh"]