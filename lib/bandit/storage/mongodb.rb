module Bandit
  class MongodbStorage < BaseStorage
    def initialize(config)
      require 'mongo'
      config[:host]       ||= 'localhost'
      config[:port]       ||= 27017
      config[:db]         ||= 'bandit'
      config[:collection] ||= 'bandit'

      @connection = Mongo::Connection.new(config[:host], config[:port])
      @db         = @connection.db(config[:db])
      @collection = @db.collection(config[:collection])
      @collection.ensure_index('key')
    end

    # increment key by count
    def incr(key, count=1)
      with_failure_grace(count) {
        @collection.update({ :key => key }, { '$inc' => { :value => count }}, :upsert => true)
      }
    end

    # initialize key if not set
    def init(key, value)
      with_failure_grace(value) {
        @collection.update({ :key => key }, { '$set' => { :value => value }}, :upsert => true) if get(key, nil).nil?
      }
    end

    # get key if exists, otherwise 0
    def get(key, default=0)
      with_failure_grace(default) {
        doc = @collection.find( { :key => key }, { :limit => 1 }).first
        return default if doc.nil?
        doc['value']
      }
    end

    # set key with value, regardless of whether it is set or not
    def set(key, value)
      with_failure_grace(value) {
        @collection.update({ :key => key }, { '$set' => { :value => value } }, :upsert => true)
      }
    end

    def clear!
      with_failure_grace(nil) {
        @collection.remove
      }
    end
  end
end
