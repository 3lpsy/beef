FROM ruby:2.3.0-slim
LABEL maintainer <contact@ilyaglotov.com>

ENV LANG C.UTF-8

RUN apt-get update \
  && apt-get install -y \
    build-essential \
    git \
    sqlite3 \
    libsqlite3-dev \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -m beef

RUN git clone --depth=1 \
    --branch=master \
    https://github.com/beefproject/beef.git \
    /home/beef/beef

WORKDIR /home/beef/beef

RUN gem install rake && \
    bundle install

RUN chown -R beef /home/beef/beef \
  && rm -rf /home/beef/beef/.git \
  && apt-get -y purge \
    git \
    build-essential \
    libsqlite3-dev


VOLUME /home/beef/.beef
USER beef
EXPOSE 3000 6789 61985 61986
ENTRYPOINT ["./beef"]
