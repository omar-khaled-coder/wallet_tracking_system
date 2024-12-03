class AddCreditAndFullNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :credit, :decimal, default: 0.0
    add_column :users, :full_name, :string
  end
end
