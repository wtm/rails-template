class User < ActiveRecord::Base
  include Clearance::User
  attr_accessible :organization_id, :role, :name, :email, :password,
                  :password_confirmation, :organization_attributes

  belongs_to :organization
  accepts_nested_attributes_for :organization

  def role
    Role.new self[:role]
  end
end

