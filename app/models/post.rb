class Post < ActiveRecord::Base
  attr_accessible :content, :name, :title
validates_presence_of :content, :name, :title
end
