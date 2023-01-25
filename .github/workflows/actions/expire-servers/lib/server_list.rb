require 'nokogiri'

class ServerList
  def initialize(xml)
    @doc = Nokogiri::XML(xml)
  end 

  def remove(ids)
    @doc
      .css("ArrayOfServerItem ServerItem")
      .select { |e| ids.include?(e.at_css('id').content) }
      .each(&:remove)
  end
  
  def to_xml
    @doc.to_s
  end
end
