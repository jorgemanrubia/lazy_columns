class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :title
      t.text :comments

      t.timestamps
    end
  end
end
