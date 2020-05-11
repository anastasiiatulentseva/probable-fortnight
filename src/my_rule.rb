require 'montrose'

class MyRule

  def initialize(during, interval)
    @during   = during
    @interval = interval
    @rule     = build
  end

  def show
    @rule.to_h
  end

  def events
    @rule.events.to_a
  end

  private

  def build
    Montrose.minutely(
      interval: @interval,
      during:   @during,
      starts:   Date.today.at_beginning_of_day,
      until:    Date.tomorrow.at_beginning_of_day)
  end
end
