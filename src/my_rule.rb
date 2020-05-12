# frozen_string_literal: true

require 'montrose'
require_relative './patch'

class MyRule
  def initialize(during, interval, starts = nil, ends = nil)
    @during   = during
    @interval = interval
    @start    = starts || Date.today.at_beginning_of_day
    @end      = ends || Date.tomorrow.at_beginning_of_day
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
      during: @during,
      starts: @start,
      until: @end
    )
  end
end
