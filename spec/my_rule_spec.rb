RSpec.describe MyRule do

  describe 'during split' do

    let(:rule) { described_class.new(['3:00pm-3:20pm', '4:20pm-4:40pm'], 30) }

    it 'splits events by during intervals' do
      expect(rule.events.length).to eq(2)
    end

    it 'starts each interval in "during" time' do
      expect(rule.events.first).to be_within(1.second).of(today_at(hour: 15, minute: 00))
      expect(rule.events.last).to be_within(1.second).of(today_at(hour: 16, minute: 20))
    end

    def today_at(hour: 0, minute: 0)
      Time.new(Date.today.year, Date.today.month, Date.today.day, hour, minute, 0)
    end
  end

end
