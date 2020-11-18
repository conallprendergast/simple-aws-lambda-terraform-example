#!/usr/bin/env python3

import datetime
import requests
import sys

def handler(event, context):
    response = requests.get("http://google.com")
    print("{} - Request http://google.com - Response {}".format(datetime.datetime.now(), response.status_code))
