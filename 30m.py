#!/usr/bin/python
# -*- coding: utf-8 -*-

import requests
import os
import sys


# type: ip4/ip6
type = u'ip4'
# key: 订单分配
key = u'30mkey'
http = requests.Session()

info_res = http.get('https://dns.30m.cloud/v1/info/' + key).json()

c_ipv4 = http.get('https://api-ipv4.ip.sb/ip').text
c_ipv4 = c_ipv4[0: len(c_ipv4) - 1]
sip = info_res[u'msg'][type]

add_res = http.get('https://dns.30m.cloud/v1/add/' + key + '?c_ipv4=' + c_ipv4).json()
if add_res['ret'] == 200 or add_res['ret'] == 202:
    run_path = os.path.split(os.path.realpath(sys.argv[0]))[0]
    if run_path == '/':
        run_path = ''
    file_path = run_path + '/shadowsocks/asyncdns.py'
    os.system('sed -i "s|30mip|' + sip + '|" ' + file_path)

print(add_res)
