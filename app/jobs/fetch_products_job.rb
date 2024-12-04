class FetchProductsJob < ApplicationJob
  queue_as :default

  def perform
    response = HTTParty.get('https://fakestoreapi.com/products')
    products = JSON.parse(response.body)

    products.each do |product_data|
      Product.find_or_create_by(id: product_data['id']) do |product|
        product.name = product_data['title']
        product.price = product_data['price']
      end
    end
  end
end
