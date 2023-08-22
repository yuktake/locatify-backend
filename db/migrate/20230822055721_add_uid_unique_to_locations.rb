class AddUidUniqueToLocations < ActiveRecord::Migration[7.0]
  def change
    add_index :locations, :uid, unique: true
  end
end
