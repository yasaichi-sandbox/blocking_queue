require 'thread'

class BlockingQueue
  def initialize
    @condvar = ConditionVariable.new
    @mutex = Mutex.new
    @strage = Array.new
  end

  def push(element)
    @mutex.synchronize do
      @strage.push(element)
      @condvar.signal
    end
  end

  def pop
    @mutex.synchronize do
      while @strage.empty?
        @condvar.wait(@mutex)
      end

      @strage.shift
    end
  end

  def size
    @mutex.synchronize do
      @strage.size
    end
  end
end
