class Clearance::UsersController < ApplicationController
  unloadable

  skip_before_filter :authorize, :only => [:create, :new]

  def index
    @users = current_user.users
    render :template => 'users/index'
  end

  def show
    @user = current_user.users.find(params[:id])
    render :template => 'users/show'
  end

  def new
    @user = user_from_params
    @user.build_organization unless signed_in?

    render :template => 'users/new'
  end

  def create
    @user = user_from_params

    if @user.save
      sign_in @user unless signed_in?
      redirect_back_or url_after_create
    else
      render :template => 'users/new'
    end
  end

  def edit
    @user = current_user.users.find(params[:id])
    render :template => 'users/edit'
  end

  def update
    @user = current_user.users.find(params[:id])
    if @user.update_attributes(params[:user])
      respond_with @user
    else
      render json: @user.errors.full_messages, status: :not_acceptable
    end
  end

  private

  def url_after_create
    '/'
  end

  def user_from_params
    user_params = params[:user] || Hash.new
    email = user_params.delete(:email)
    password = user_params.delete(:password)

    Clearance.configuration.user_model.new(user_params).tap do |user|
      user.email = email
      user.password = password
    end
  end
end
