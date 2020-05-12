require 'montrose'
require_relative './patch'

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
    @rule.events
  end

  private

  def build
    Montrose.minutely(
      throttle_for: @interval * 60, # minutes
      during:   @during,
      starts:   Date.today.at_beginning_of_day,
      until:    Date.tomorrow.at_beginning_of_day)
  end
end
