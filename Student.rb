require 'dm-core'
require 'dm-migrations'

DataMapper::Logger.new($stdout, :debug)

configure :development do
  DataMapper.setup(:default,"sqlite3://#{Dir.pwd}/students.db")
end

configure :production do
  DataMapper.setup(:default,ENV['DATABASE_URL'])
end

class Student
  include DataMapper::Resource
  property :id, Serial
  property :firstname, String, :required => true
  property :lastname, String, :required => true
  property :student_id, String, :required => true
  property :birthday, Date
  property :address, String
end

DataMapper.auto_upgrade!
