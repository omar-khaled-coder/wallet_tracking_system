class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  def home
  end

  def user_profile
    @user = User.find(params[:id]) # Find the user by ID from the URL
    @transactions = @user.transactions.order(created_at: :desc)
  end
end
