FROM node:latest AS jsbuilder
WORKDIR /srv/rapidpro
RUN chown node:node -R /srv/rapidpro
USER node
COPY --chown=node package.json yarn.lock ./
RUN yarn install --immutable


FROM python:3.11-bookworm AS base
ENV PATH=/srv/rapidpro/.local/bin/:$PATH
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
RUN adduser --uid 1000 --disabled-password --gecos '' --home /srv/rapidpro rapidpro
WORKDIR /srv/rapidpro/rapidpro
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
        && apt-get -yq update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y \
                unattended-upgrades \
                # rapidpro dependencies
                libgdal-dev \
                nodejs \
                # ssl certs to external services
                ca-certificates \
        && npm install -g yarn \
        && yarn global add less \
        && rm -rf /var/lib/apt/lists/* \
        && apt-get clean


FROM base AS pybuilder
ENV POETRY_VIRTUALENVS_CREATE=false

RUN apt-get -yq update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y \
                build-essential \
                # CFFI deps
                libffi-dev \
                libssl-dev \
                # psycopg2 deps
                libpq-dev \
        && rm -rf /var/lib/apt/lists/* \
        && apt-get clean
COPY --chown=rapidpro pyproject.toml poetry.lock ./
RUN pip install --no-cache-dir poetry
RUN poetry install --only main
USER rapidpro



FROM pybuilder AS rapidpro
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
COPY --chown=rapidpro --from=jsbuilder /srv/rapidpro/node_modules/ ./node_modules/
COPY --chown=rapidpro . /srv/rapidpro/rapidpro/
USER rapidpro
EXPOSE 8000
ENTRYPOINT ["/srv/rapidpro/rapidpro/entrypoint"]
