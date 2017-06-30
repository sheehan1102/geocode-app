class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :address_one
      t.string :address_two
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :lat
      t.string :long
    end
  end
end
