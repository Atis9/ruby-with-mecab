FROM ruby:3.3.0-alpine

ENV MECAB_VERSION 0.996
ENV MECAB_IPADIC_VERSION 2.7.0-20070801
ENV mecab_url https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE
ENV mecab_ipadic_url https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM

RUN set -x \
  && apk add --update --no-cache bash \
  && apk add --update --no-cache --virtual .build-deps \
    build-base curl file openssl \
  && cd /tmp \
  && curl -SL -o mecab-${MECAB_VERSION}.tar.gz ${mecab_url} \
  && tar zxf mecab-${MECAB_VERSION}.tar.gz \
  && cd mecab-${MECAB_VERSION} \
  && if [ `uname -m` =  "aarch64" ]; then \
    ./configure --enable-utf8-only --with-charset=utf8 --build=arm-unknown-linux-gnu --host=arm-unknown-linux-gnu --target=arm-unknown-linux-gnu; \
  else \
    ./configure --enable-utf8-only --with-charset=utf8; \
  fi \
  && make \
  && make install \
  && cd /tmp \
  && curl -SL -o mecab-ipadic-${MECAB_IPADIC_VERSION}.tar.gz ${mecab_ipadic_url} \
  && tar zxf mecab-ipadic-${MECAB_IPADIC_VERSION}.tar.gz \
  && cd mecab-ipadic-${MECAB_IPADIC_VERSION} \
  && if [ `uname -m` =  "aarch64" ]; then \
    ./configure --with-charset=utf8 --build=arm-unknown-linux-gnu --host=arm-unknown-linux-gnu --target=arm-unknown-linux-gnu; \
  else \
    ./configure --with-charset=utf8; \
  fi \
  && make \
  && make install \
  && gem install natto \
  && apk del .build-deps \
  && rm -rf /tmp/mecab-*

CMD ["irb"]
