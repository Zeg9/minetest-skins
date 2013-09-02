#!/usr/bin/python3
from http.client import HTTPConnection
import json
import base64

server = "minetest.fensta.bplaced.net"
skinsdir = "skins/textures/"
metadir = "skins/meta/"

c = HTTPConnection(server)
c.request("GET","/api/get.json.php?getlist&page=1&outformat=base64")
r = c.getresponse()
if r.status != 200:
	print("Error", r.status)
	exit(r.status)
data = r.read().decode()
l = json.loads(data)
if not l["success"]:
	print("Success != True")
	exit(1)
i = 1
for s in l["skins"]:
	f = open(skinsdir+"character_"+str(i)+".png",'wb')
	f.write(base64.b64decode(s["img"]))
	f.close()
	f = open(metadir+"character_"+str(i)+".txt",'w')
	f.write('name = "'+s["name"]+'",\n')
	f.write('author = "'+s["author"]+'",\n')
	f.write('comment = "'+s["license"]+'",\n')
	f.close()
	i = i + 1
print("Skins have been updated. Please run ./generate_previews.sh")

