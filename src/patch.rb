# new rule
module Montrose
  module Rule
    class ThrottleFor
      include Montrose::Rule

      def self.apply_options(opts)
        opts[:throttle_for]
      end

      def initialize(throttle_for)
        @throttle_for = throttle_for
        @last_tick = nil
      end

      def include?(time)
        return true if @last_tick.nil?
        time - @last_tick > @throttle_for
      end

      def advance!(time)
        @last_tick = time
        continue?(time)
      end

      def continue?(_time)
        true
      end
    end
  end
end

# add option accessors
Montrose::Options.class_eval do
  def_option :throttle_for
end

# inject our new rule into the engine
Montrose::Stack.singleton_class.prepend(Module.new do
  def build(opts = {})
    super + [
        Montrose::Rule::ThrottleFor,
    ].map { |r| r.from_options(opts) }.compact
  end
end)
