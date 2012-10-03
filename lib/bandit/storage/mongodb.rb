module Bandit
  class MongodbStorage < BaseStorage
    def initialize(config)
      require 'mongo'
      config[:host]       ||= 'localhost'
      config[:port]       ||= 27017
      config[:db]         ||= 'bandit'
      config[:colleciton] ||= 'bandit'

      @connection = Mongo::Connection.new(config[:host], config[:port])
      @db         = @connection.db(config[:db])
      @collection = @db.collection(config[:collection])
    end

    # increment key by count
    def incr(key, count=1)
      with_failure_grace(count) {
        # @redis.incrby(key, count)
      }
    end

    # initialize key if not set
    def init(key, value)
      with_failure_grace(value) {
        # @redis.set(key, value) if get(key, nil).nil?
      }
    end

    # get key if exists, otherwise 0
    def get(key, default=0)
      with_failure_grace(default) {
        # val = @redis.get(key)
        # return default if val.nil?
        # val.numeric? ? val.to_i : val
      }
    end

    # set key with value, regardless of whether it is set or not
    def set(key, value)
      with_failure_grace(value) {
        # @redis.set(key, value)
      }
    end

    def clear!
      with_failure_grace(nil) {
        # @redis.flushdb
      }
    end
  end
end
