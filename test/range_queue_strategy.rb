require 'base_queue_strategy'

class RangeQueueStrategy < BaseQueueStrategy
  include ModernTimes::Stoppable

  def initialize(range, is_replay=false, replay_sleep=1)
    super()
    @range = range
    @is_replay = is_replay
    @replay_sleep
    @count = range.first
  end

  def receive(session)
    mutex.synchronize do
      if @count > @range.last
        if @is_replay
          # Don't clobber cpu
          sleep @replay_sleep
          return nil if stopped?
          @count = @range.first
        else
          return nil
        end
      end
      @count += 1
      return @count-1
    end
  end
end