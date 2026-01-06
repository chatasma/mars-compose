FROM ubuntu:noble
WORKDIR /workspace
COPY api.sh /workspace/api.sh
RUN chmod +x /workspace/api.sh
ENV RUST_BACKTRACE=1
ENTRYPOINT ["/usr/bin/env", "bash", "/workspace/api.sh"]
