require 'net/http'
require 'json'

class FetchProductsService
  API_URL = "https://fakestoreapi.com/products".freeze

  def self.call
    uri = URI(API_URL)
    response = Net::HTTP.get(uri)
    products = JSON.parse(response)

    products.each do |product|
      Product.find_or_create_by(id: product["id"]) do |p|
        p.name = product["title"]
        p.price = product["price"]
        p.description = product["description"]
      end
    end
  end
end
