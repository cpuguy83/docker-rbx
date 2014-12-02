FROM debian:jessie
ENV RBX_VERSION 2.4.0
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8
RUN apt-get update && apt-get install -y --no-install-recommends ruby curl bzip2 make gcc libc6-dev g++ ruby-dev automake flex bison libedit-dev llvm-dev zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev locales patch \
  && mkdir /usr/src/rbx \
  && curl -sSL http://releases.rubini.us/rubinius-${RBX_VERSION}.tar.bz2 \
  | tar -xjC /usr/src/rbx \
  && cd /usr/src/rbx/rubinius-${RBX_VERSION} \
  && gem install bundler \
  && bundle \
  && SHELL=/bin/bash ./configure --prefix=/usr/local/rubinius \
  && SHELL=/bin/bash rake install clean \
  && cd / && rm -rf /usr/src/rbx \
  && apt-get purge -y --auto-remove ruby ruby-dev g++ bison llvm llvm-dev zlib1g-dev libbison-dev \
  && rm -rf /var/lib/apt/lists/*
ENV GEM_HOME /usr/local/bundle
ENV PATH /usr/local/rubinius/bin:$GEM_HOME/bin:$PATH
RUN  gem install bundler --no-ri --no-rdoc
RUN bundle config --global path "$GEM_HOME" \
  && bundle config --global bin "$GEM_HOME/bin"
ENV BUNDLE_APP_CONFIG $GEM_HOME

CMD ["irb"]
