import os

if os.name == "nt":
    PING_CMD = "ping"
else:
    PING_CMD = "ping -c 4"

path = "Ping_test/webpages.txt"
