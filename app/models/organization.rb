class Organization < ActiveRecord::Base
  has_many :users, dependent: :destroy
  attr_accessible :name
end

