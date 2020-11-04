FROM debian
RUN apt-get update && apt-get -y upgrade && apt-get install -y \
    wget \
    openjdk-11-jre-headless

VOLUME /app/
WORKDIR /app

COPY ./entrypoint.sh /
ENTRYPOINT ["sh", "/entrypoint.sh"]
