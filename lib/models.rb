require "sequel"
require "digest/sha1"

module Flashlight
  
  module Status
    
    NEW = "new"
    OPEN = "open"
    FIXED = "fixed"
    WONT_FIX = "won't fix"
    CLOSED = "closed"
    
  end
  
  DB = Sequel.connect('sqlite://db/development.db')
  
  # Let the model initialize itself for now. This should be moved to a rack task or something
  if DB.tables.empty?
    DB.create_table :users do
      primary_key :id
      column :email, :string
      column :password, :string
      column :name, :string
      column :auth_key, :string
    end
    
    DB.create_table :issues do
      primary_key :id
      column :creator_id, :string
      column :assignee_id, :string
      column :title, :string
      column :description, :string
      column :status, :string
      column :created_on, :datetime
      column :updated_on, :datetime
    end
    
    DB.create_table :entries do
      primary_key :id
      column :issue_id, :string
      column :entry, :text
      column :timestamp, :datetime
    end
    
    # Create the admin user
    users = DB[:users]
    
    users << { :email=>"admin@flashlight.bitgroup.com", :name=>"Admin", :password=>"admin", :auth_key => Digest::SHA1.hexdigest("admin@flashlight.bitgroup.com:Admin") }
  end
  
  class User < Sequel::Model
    before_create do
      # generate the user's unique key
      #values.merge!({:auth_key => "#{Digest::SHA1.hexdigest([values["email"], values["password"].jo])}"})
      values.merge!({ :auth_key => Digest::SHA1.hexdigest([values["email"],values["name"]].join) })
    end
    
    def self.authenticate(email, password)
      if user = self[:email => email, :password => password]
        return user.auth_key
      end
    end
    
    def self.valid_auth_key?(auth_key)
      if user = self[:auth_key => auth_key]
        return true
      end
      return false
    end
  end
  
  class Issue < Sequel::Model
  end
  
  class Entry < Sequel::Model
  end
end