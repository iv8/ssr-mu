FROM alpine

MAINTAINER IV8<admin@30m.cloud>

ENV NODE_ID=0                     \
 SPEEDTEST=6                   \
 CLOUDSAFE=0                   \
 AUTOEXEC=0                    \
 ANTISSATTACK=0                \
 MU_SUFFIX=zhaoj.in            \
 MU_REGEX=%5m%id.%suffix       \
 API_INTERFACE=modwebapi       \
 WEBAPI_URL=https://zhaoj.in   \
 WEBAPI_TOKEN=glzjin           \
 MYSQL_HOST=127.0.0.1          \
 MYSQL_PORT=3306               \
 MYSQL_USER=ss                 \
 MYSQL_PASS=ss                 \
 MYSQL_DB=shadowsocks          \
 KEY=12345

COPY .git /root/shadowsocks/.git
WORKDIR /root/shadowsocks
RUN apk --no-cache add curl python python-dev libsodium-dev openssl-dev udns-dev mbedtls-dev pcre-dev libev-dev libtool libffi-dev &&\
 apk --no-cache add --virtual .build-deps git tar make py-pip autoconf automake build-base linux-headers && \
 git reset --hard && pip install --upgrade pip && pip install -r requirements.txt &&\
 pip install idna &&\
 rm -rf ~/.cache .git && touch /etc/hosts.deny &&\
 apk del --purge .build-deps

CMD sed -i "s|NODE_ID = 1|NODE_ID = ${NODE_ID}|"                            apiconfig.py &&\
 sed -i "s|SPEEDTEST = 6|SPEEDTEST = ${SPEEDTEST}|"                         apiconfig.py &&\
 sed -i "s|CLOUDSAFE = 1|CLOUDSAFE = ${CLOUDSAFE}|"                         apiconfig.py &&\
 sed -i "s|AUTOEXEC = 0|AUTOEXEC = ${AUTOEXEC}|"                            apiconfig.py &&\
 sed -i "s|ANTISSATTACK = 0|ANTISSATTACK = ${ANTISSATTACK}|"                apiconfig.py &&\
 sed -i "s|MU_SUFFIX = 'zhaoj.in'|MU_SUFFIX = '${MU_SUFFIX}'|"              apiconfig.py &&\
 sed -i "s|MU_REGEX = '%5m%id.%suffix'|MU_REGEX = '${MU_REGEX}'|"           apiconfig.py &&\
 sed -i "s|API_INTERFACE = 'modwebapi'|API_INTERFACE = '${API_INTERFACE}'|" apiconfig.py &&\
 sed -i "s|WEBAPI_URL = 'https://zhaoj.in'|WEBAPI_URL = '${WEBAPI_URL}'|"   apiconfig.py &&\
 sed -i "s|WEBAPI_TOKEN = 'glzjin'|WEBAPI_TOKEN = '${WEBAPI_TOKEN}'|"       apiconfig.py &&\
 sed -i "s|MYSQL_HOST = '127.0.0.1'|MYSQL_HOST = '${MYSQL_HOST}'|"          apiconfig.py &&\
 sed -i "s|MYSQL_PORT = 3306|MYSQL_PORT = ${MYSQL_PORT}|"                   apiconfig.py &&\
 sed -i "s|MYSQL_USER = 'ss'|MYSQL_USER = '${MYSQL_USER}'|"                 apiconfig.py &&\
 sed -i "s|MYSQL_PASS = 'ss'|MYSQL_PASS = '${MYSQL_PASS}'|"                 apiconfig.py &&\
 sed -i "s|MYSQL_DB = 'shadowsocks'|MYSQL_DB = '${MYSQL_DB}'|"              apiconfig.py &&\
 sed -i "s|30mkey|${KEY}|" 30m.py && python 30m.py &&\
 python -u server.py
