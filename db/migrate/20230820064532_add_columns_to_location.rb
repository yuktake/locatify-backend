class AddColumnsToLocation < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :track_name, :string, :null => false
    add_column :locations, :artist_name, :string, :null => false
  end
end
