class AddColumnToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :thumbnail, :string, :null => false
    add_column :locations, :preview_url, :string
  end
end
