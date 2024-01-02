FROM rust:1.75 AS builder

ENV APP_ROOT /app
WORKDIR $APP_ROOT

COPY . $APP_ROOT

RUN set -eux; \
    apt-get update; \
    apt-get install -y ca-certificates; \
    cargo install sqlx-cli --no-default-features --features mysql; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
      amd64) rustArch='x86_64-unknown-linux-gnu';; \
      rmhf) rustArch='armv7-unknown-linux-gnueabihf' ;; \
      arm64) rustArch='aarch64-unknown-linux-gnu' ;; \
      i386) rustArch='i686-unknown-linux-gnu' ;; \
      *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    rustup target add $rustArch; \
    cargo build --release --target=$rustArch; \
    cp $APP_ROOT/target/$rustArch/release/linebot /usr/local/bin/linebot; \

FROM debian:bookworm-slim

ENV APP_ROOT /app
WORKDIR $APP_ROOT

RUN set -eux; \
    apt-get update; \
    apt-get install -y ca-certificates libssl-dev; \
    rm -rf /var/lib/apt/lists/*; \

COPY --from=bulder /usr/local/bin/linebot /usr/local/bin/linebot
COPY --from=builder /usr/local/cargo/bin/sqlx /usr/local/bin/sqlx

RUN chmod +x /usr/local/bin/linebot /usr/local/bin/sqlx

EXPOSE 3000

ENTRYPOINT ["/bin.sh", "-c", "sqlx db create && sqlx migrate run && /usr/local/bin/linebot"]
