require 'minitest/autorun'
require 'minitest/spec'
require 'thread'
require 'timeout'
require_relative 'blocking_queue'

describe BlockingQueue do
  before do
    @queue = BlockingQueue.new
  end

  describe '#push' do
    it 'is probably thread-safe' do
      num_of_threads = 10
      expected_size = 10_000

      num_of_threads.times.map do
        Thread.new do
          (expected_size / num_of_threads).times do
            @queue.push(nil)
          end
        end
      end.each(&:join)

      # NOTE: The size is frequently not equal to the expectation in JRuby
      # if `#push` implementation is not thread-safe.
      assert_equal expected_size, @queue.size
    end
  end

  describe '#pop' do
    it 'returns an element in FIFO order' do
      @queue.push(first = 1)
      @queue.push(second = 2)

      assert_equal first, @queue.pop
      assert_equal second, @queue.pop
    end

    it 'blocks and waits for an element to become when it is empty' do
      begin
        Timeout.timeout(3) do
          @queue.pop
        end
      rescue => e
        assert e.is_a?(Timeout::Error)
      end
    end
  end
end

