class AddNotesToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :note, :text
  end
end
