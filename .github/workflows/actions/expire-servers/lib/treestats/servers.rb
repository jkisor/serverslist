require 'uri'
require 'net/http'
require 'json'
require './lib/server'

module TreeStats
  class Servers
    def self.all
      response = fetch
      parse(response.body)
    end

    def self.expired
      all.select(&:expired?)
    end
  
    def self.fetch
      Net::HTTP.get_response(URI('https://servers.treestats.net/api/servers/'))
    end
  
    def self.parse(body)
      JSON
        .parse(body)
        .map do |server| 
          Server.new(
            id: server['guid'],
            last_seen: DateTime.parse(server.dig('status','last_seen'))
          )
        end
    end
  end
end
