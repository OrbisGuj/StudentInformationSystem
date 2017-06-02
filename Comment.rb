require 'dm-core'
require 'dm-migrations'

#DataMapper::Logger.new($stdout, :debug)
configure :development do
  DataMapper.setup(:default,"sqlite3://#{Dir.pwd}/comments.db")
end

configure :production do
  DataMapper.setup(:default,ENV['DATABASE_URL'])
end

class Comment
include DataMapper::Resource # mixin
  property :id, Serial, :required => true
  property :title, String, :required => true
  property :name, String, :required => true
  property :content, Text, :required => true
  property :created_at, DateTime, :required => true
end

DataMapper.auto_upgrade!
