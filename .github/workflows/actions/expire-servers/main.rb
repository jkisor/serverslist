require 'uri'
require 'net/http'
require 'nokogiri'
require 'json'
require 'date'

WORKSPACE_DIR = '/github/workspace'
MONTHS_UNTIL_EXPIRED = 3

class FetchTreeStatsServers
  def call
    response = submit_request
    parse(response)
  end

  private

  def submit_request
    Net::HTTP.get_response(URI('https://servers.treestats.net/api/servers/'))
  end

  def parse(response)
    JSON
      .parse(response.body)
      .map do |server| 
        { 
          id: server['guid'],
          last_seen: DateTime.parse(server.dig('status','last_seen')) 
        }
      end
  end
end

servers = FetchTreeStatsServers.new.call

expire_time = DateTime.now.prev_month(MONTHS_UNTIL_EXPIRED)
expired_servers = servers.select { |s| s[:last_seen] <= expire_time}
# expired_server_ids = expired_servers.map { |s| s[:id] }
expired_server_ids = ['ea2c553a-11a8-4e9c-a96a-5d32e57c3143'] # TODO remove, this is for debug purposes

contents = File.read("#{WORKSPACE_DIR}/Servers.xml")
doc = Nokogiri::XML(contents)

doc.css("ArrayOfServerItem ServerItem")
  .select { |element| expired_server_ids.include?(element.at_css('id').content) }
  .each(&:remove)

File.write("#{WORKSPACE_DIR}/Servers.xml", doc.to_s)