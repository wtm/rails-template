class ApplicationController < ActionController::Base
  include Clearance::Authentication
  before_filter :authorize
  helper_method :current_organization
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def current_organization
    current_user.organization
  end

  def current_user
    super || guest_user
  end

  def guest_user
    User.new(role: "GUEST", organization_attributes: { name: "" })
  end
end

