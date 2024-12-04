class WalletController < ApplicationController
  before_action :authenticate_user!

  def top_up
    amount = params[:amount].to_f
    if amount > 0
      current_user.credit += amount
      current_user.save
      Transaction.create(user: current_user, transaction_type: "top-up", amount: amount)
      flash[:notice] = "Wallet topped up successfully!"
    else
      flash[:alert] = "Invalid amount!"
    end
    redirect_to root_path
  end

  def purchase
    product = Product.find(params[:product_id])
    if current_user.credit >= product.price
      current_user.credit -= product.price
      current_user.save
      Transaction.create(user: current_user, transaction_type: "purchase", amount: -product.price)
      flash[:notice] = "Product purchased successfully!"
    else
      flash[:alert] = "Insufficient credits!"
    end
    redirect_to root_path
  end
end
