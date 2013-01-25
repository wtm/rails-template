class Role
  include ActiveModel::Validations

  attr_accessor :name
  validates_presence_of :name

  def initialize(role)
    role ||= "GUEST"
    # valid roles can be found in config/initializers/roles.rb
    raise ArgumentError, "Invalid Role: #{role}" unless VALID_ROLES.include? role
    @name = role

    # creates helper methods to check role. for each valid_role,
    # self.valid_role? will be created
    class << self
      VALID_ROLES.each do |role|
        define_method "#{role.downcase}?".to_sym do
          self.name == role
        end
      end
    end
  end
end

