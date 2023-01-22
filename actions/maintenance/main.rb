require 'uri'
require 'net/http'
require 'nokogiri'
require 'json'
require 'date'

MONTHS_UNTIL_EXPIRED = 3

class FetchServers
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

servers = FetchServers.new.call

expire_time = DateTime.now.prev_month(MONTHS_UNTIL_EXPIRED)

expired_servers = servers.select { |s| s[:last_seen] <= expire_time}
expired_server_ids = expired_servers.map { |s| s[:id] }

puts expired_server_ids.inspect
response = Net::HTTP.get_response(URI('https://raw.githubusercontent.com/acresources/serverslist/master/Servers.xml'))
doc = Nokogiri::XML(response.body)

doc.css("ArrayOfServerItem ServerItem")
  .select { |element| expired_server_ids.include?(element.at_css('id').content) }
  .each(&:remove)

# puts doc.to_s