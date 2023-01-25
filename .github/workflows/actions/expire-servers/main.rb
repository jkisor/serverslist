require './lib/treestats/servers'
require './lib/server_list'

FILE_PATH = '/github/workspace/Servers.xml'

xml = File.read(FILE_PATH)
server_list = ServerList.new(xml)
expired = TreeStats::Servers.expired

ids = expired.map(&:id)
server_list.remove(ids)

File.write(FILE_PATH, server_list.to_xml)
