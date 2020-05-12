FROM ruby:2.6.5-alpine3.10
ENV LANG C.UTF-8
RUN apk upgrade && \
    apk add --no-cache \
    bash \
    build-base \
    curl-dev \
    gdbm-dev \
    git \
    graphviz \
    imagemagick \
    imagemagick-dev \
    less \
    libxml2-dev \
    libxslt-dev \
    nodejs \
    npm \
    openssl \
    postgresql-dev \
    readline \
    readline-dev \
    ruby-dbm \
    tar \
    ttf-freefont \
    tzdata \
    udev \
    wget \
    yaml \
    yaml-dev\
    zlib \
    zlib-dev

RUN npm install -g yarn
RUN npm install -g npm

RUN gem install bundler
RUN gem update

ENV APP_HOME /guuzen
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ENV GEM_HOME=/bundle

ADD Gemfile* $APP_HOME/

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_JOBS=4 \
  BUNDLE_PATH=$GEM_HOME

ADD . $APP_HOME
