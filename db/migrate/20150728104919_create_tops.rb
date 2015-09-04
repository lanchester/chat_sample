class CreateTops < ActiveRecord::Migration
  def change
    create_table :tops do |t|

      t.timestamps null: false
    end
  end
end
