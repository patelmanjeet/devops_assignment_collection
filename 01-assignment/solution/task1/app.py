import requests
import time
from datetime import datetime

apiUrl = 'http://worldclockapi.com/api/json/est/now'

while True:
    try:
        r = requests.get(apiUrl)
        if r.status_code != 200:
            raise Exception("status_code" + r.status_code )
        jsonData = r.json()
        print("{} - {}".format(datetime.now(),jsonData['currentDateTime']))
    except Exception as e:
        print("{} - Fail to connect api server - {}".format(datetime.now(),e))

    time.sleep(60)
