# frozen_string_literal: true
require 'benchmark'

RSpec.describe MyRule do
  describe 'during split' do
    let(:rule) { described_class.new(%w[3:00pm-3:20pm 4:20pm-4:40pm], 30) }
    let(:events) { rule.events.to_a }
    let(:week_rule) do
      described_class.new(
        %w[3:00pm-3:20pm 4:20pm-4:40pm],
        17,
        Date.today.at_beginning_of_day,
        Date.today.next_week.at_beginning_of_day
      )
    end

    let(:year_rule) do
      described_class.new(
        %w[9:00am-1:00pm 2:00pm-5:45pm],
        45,
        Date.today.at_beginning_of_day,
        Date.today.next_year.at_beginning_of_day
      )
    end

    it 'splits events by during intervals' do
      expect(events.length).to eq(2)
    end

    it 'starts each interval in "during" time' do
      expect(events.first).to be_within(1.second).of(today_at(hour: 15, minute: 0o0))
      expect(events.last).to be_within(1.second).of(today_at(hour: 16, minute: 20))
    end

    it 'creates events started exact same time from day to day' do
      slots = week_rule.events.map { |v| v.strftime('%H:%M') }.uniq
      expect(slots).to eq(%w[15:00 15:17 16:20 16:37])
    end

    it 'selects events quite fast' do
      time = Benchmark.realtime do
        year_rule.events.take_while{|event| event.to_date <= Date.today.next_week}.select { |event| event.to_date == Date.today.next_week }
      end

      expect(time).to be <= 2
    end

    it 'works inside schedule as well' do
      rule2 = described_class.new(
        %w[9:00am-9:20am 6:20pm-6:40pm],
        16,
        Date.today.at_beginning_of_day,
        Date.today.next_week.at_beginning_of_day
      )

      schedule = Montrose::Schedule.build do |montrose_rule|
        montrose_rule << week_rule.show
        montrose_rule << rule2.show
      end
      events   = schedule.events
                         .select { |event| event.to_date == Date.today + 3.days }
                         .map { |v| v.strftime('%H:%M') }
      expect(events).to eq(%w[09:00 09:16 15:00 15:17 16:20 16:37 18:20 18:36])
    end

    def today_at(hour: 0, minute: 0)
      Time.new(Date.today.year, Date.today.month, Date.today.day, hour, minute, 0)
    end
  end
end
