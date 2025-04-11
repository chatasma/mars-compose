FROM amazoncorretto:21-alpine-jdk
WORKDIR /workspace
RUN apk update
RUN apk add wget git unzip bash
EXPOSE 25565
COPY mcsrv.sh /workspace/mcsrv.sh
RUN chmod +x /workspace/mcsrv.sh
CMD ["/usr/bin/env", "bash", "/workspace/mcsrv.sh"]
