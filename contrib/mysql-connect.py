from urllib.parse import urlparse
import sys
import os

url = sys.argv[1] if len(sys.argv) > 1 else os.environ.get('DATABASE_URL')
#sql = sys.argv[2]
data = urlparse(url)

hostname = data.netloc.split('@')[-1]
[hostname, port] = hostname.split(':')

print(hostname)
print(port)
print(data.username)
print(data.password)
print(data.path[1:])

config = {
        "mysql": "/usr/local/opt/mysql-client@5.7/bin/mysql",
        "host": hostname,
        "user": data.username,
        "pass": data.password,
        "db":   data.path[1:],
        "port": port,
        #"sql": sql,
        }

#cmd = "{mysql} --host={host} --user={user} --password={pass} {db} --execute='{sql}'".format(**config)
cmd = "{mysql} --host={host} --user={user} --password={pass} --port={port} {db}".format(**config)
os.system(cmd)
