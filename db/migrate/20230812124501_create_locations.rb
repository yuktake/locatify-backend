class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :uid
      t.string :mid
      t.geometry :point

      t.timestamps
    end
  end
end
