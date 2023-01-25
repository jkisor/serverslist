require 'date'

class Server
  MONTHS_TIL_EXPIRED = 3

  def initialize(id: , last_seen:)
    @id = id
    @last_seen = last_seen
  end

  def expired?
    @last_seen <= DateTime.now.prev_month(MONTHS_TIL_EXPIRED)
  end
end
