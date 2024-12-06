class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    # Clear existing products before inserting new data
    Product.delete_all  # Deletes all products in the database

    # Fetch product data from the external API
    response = HTTParty.get('https://fakestoreapi.com/products')
    products_data = JSON.parse(response.body)

    # Save products in the database
    products_data.each do |product_data|
      Product.create(
        name: product_data["title"],
        price: product_data["price"],
        image: product_data["image"]
      )
    end

    # Load all products for display
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end
end
