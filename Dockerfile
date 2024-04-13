FROM python:3.11-slim as builder
WORKDIR /project

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# install rye
ENV RYE_HOME "/opt/rye"
ENV PATH "$RYE_HOME/shims:$PATH"
ENV RYE_NO_AUTO_INSTALL "1"
ENV RYE_INSTALL_OPTION "--yes" 
ENV RYE_TOOLCHAIN "/usr/local/bin/python"
RUN curl -sSf https://rye-up.com/get | bash

# config rye
RUN rye config --set-bool behavior.use-uv=true

# install dependencies
RUN rye pin --relaxed 3
COPY pyproject.toml /project/
RUN rye sync --no-dev --all-features

# if you have requirements.lock, copy it too
#COPY pyproject.toml requirements.lock /project/
#RUN rye sync --no-dev --no-lock

FROM python:3.11-slim
WORKDIR /project

COPY --from=builder /project/.venv /project/.venv
ENV PATH /project/.venv/bin:$PATH
COPY src/ /project/

ENV N_WORKERS 4

CMD uvicorn \
    --access-log \
    --host 0.0.0.0 \
    --port 8080 \
    --workers ${N_WORKERS} \
    app.server:app                              
