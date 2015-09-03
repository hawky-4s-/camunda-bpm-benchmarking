#import csv
from docker import Client

cli = Client(base_url='tcp://ci1.camunda.loc:2375')
stats_obj = cli.stats('registry', False)
for stat in stats_obj:
   print(stat)

