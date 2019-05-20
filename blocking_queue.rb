require 'thread'

class BlockingQueue
  def initialize
    @mutex = Mutex.new
    @strage = Array.new
  end

  def push(element)
    @mutex.synchronize do
      @strage.push(element)
    end
  end

  def pop
    @mutex.synchronize do
      @strage.shift
    end
  end

  def size
    @mutex.synchronize do
      @strage.size
    end
  end
end
