class WalletController < ApplicationController
  before_action :authenticate_user!

  def top_up
    amount = params[:amount].to_d rescue 0
    Rails.logger.debug "Top-up amount: #{amount}"

    if amount > 0
      current_user.with_lock do
        current_user.update!(credit: current_user.credit + amount)
        current_user.transactions.create!(transaction_type: "top-up", amount: amount)
      end
      flash[:notice] = "Top-up successful!"
    else
      flash[:alert] = "Invalid top-up amount."
    end

    redirect_to user_profile_path(current_user)
  rescue => e
    Rails.logger.error "Top-up failed: #{e.message}"
    flash[:alert] = "Top-up failed."
    redirect_to user_profile_path(current_user)
  end

  def purchase
    product = Product.find(params[:product_id])

    if product.price <= 0
      flash[:alert] = "Invalid product price."
      return redirect_to root_path
    end

    current_user.with_lock do
      if current_user.credit >= product.price
        current_user.update!(credit: current_user.credit - product.price)
        current_user.transactions.create!(transaction_type: "purchase", amount: -product.price)
        flash[:notice] = "Product purchased successfully!"
      else
        flash[:alert] = "Insufficient credits!"
      end
    end

    redirect_to root_path
  rescue => e
    Rails.logger.error "Purchase failed: #{e.message}"
    flash[:alert] = "Purchase failed."
    redirect_to root_path
  end
end
