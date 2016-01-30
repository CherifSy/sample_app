class UsersController < ApplicationController
  # Authentication and Authorization
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    # Here the page parameter comes from params[:page], 
    # which is generated automatically by will_paginate in index.html.erb
    @users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find(params[:id])
  	# | byebug debugger command.
  	#debugger  	
  	# | Use "debugger" and Rails console will be added in the
  	# | rails server console. 
  	# | When happy, Ctrl+D to resume execution.
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
      log_in @user
      # Temporary message on succesful user sign-up.
      flash[:success] = "Welcome to the sample app!"
      # Redirect to user profile.
      redirect_to @user
      # | Same as above
      #redirect_to user_url(@user)

    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # "BEFORE" FILTERS
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      # Refactored and more expressive using session helper.
      redirect_to(root_url) unless current_user?(@user)
      # Original
      # redirect_to(root_url) unless @user == current_user
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end