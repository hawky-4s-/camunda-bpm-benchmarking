import sys, http.client, json, csv, datetime

if len(sys.argv) != 2:
  print('Usage: python <script> <cAdvisorHost>:<port> <monitoredContainerId>')
  quit()

# example: 2015-09-03T14:27:59.219503826Z
dateFormat = '%Y-%m-%dT%H:%M:%S'

def asDateTime(dateString):
  # parse string without sub seconds first
  parsedDateTime = datetime.datetime.strptime(dateString[:19], dateFormat)

  # some extra magic since cAdvisor removes pending zeroes at the end of the subSecond string
  subSecondString = dateString[19:][1:-1]
  nanoSeconds = int(subSecondString) * (10**(9 - len(subSecondString)))

  # datetime can't deal with nanoseconds
  parsedDateTime + datetime.timedelta(0, 0, nanoSeconds / 10**3)

  return parsedDateTime

cadvisorHost = sys.argv[1]
containerId = sys.argv[2]

# TODO: read these optionally from command line
outfile = 'out.csv'
numCpus = 8

params = json.dumps({'num_stats' : -1, 'num_samples' : 0})
headers = {'Content-Type' : 'application/json'}
connection = http.client.HTTPConnection(cadvisorHost)
connection.request('POST', '/api/v1.3/containers/system.slice/docker-' + containerId + '.scope', params, headers)
response = connection.getresponse()

if (response.status / 100) != 2:
  raise Exception('Request not successful; got status code ' + response.status)

responsebody = json.loads(response.read().decode('utf-8'))

with open(outfile, 'w') as csvfile:
  fieldnames = ['timestamp']
  for i in range(numCpus):
    fieldnames.append('cpu' + str(i))

  writer = csv.DictWriter(csvfile, fieldnames=fieldnames, delimiter=',', lineterminator='\n')
  writer.writeheader()

  stats = responsebody['stats']
  for index, stats_instance in enumerate(stats):
    if index > 0:
      previous_instance = stats[index - 1]

      row = {'timestamp' : stats_instance['timestamp']}
      interval = asDateTime(stats_instance['timestamp']) - asDateTime(previous_instance['timestamp'])
      intervalInNanoSeconds = (interval.seconds * 10**6 + interval.microseconds) * 10**3

      cpuUsageDetails = stats_instance['cpu']['usage']
      for cpuIndex, cpuUsage in enumerate(cpuUsageDetails['per_cpu_usage']):
        row['cpu' + str(cpuIndex)] = (cpuUsage - previous_instance['cpu']['usage']['per_cpu_usage'][cpuIndex]) / intervalInNanoSeconds

      writer.writerow(row)
