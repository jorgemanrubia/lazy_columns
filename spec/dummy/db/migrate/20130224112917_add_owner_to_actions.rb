class AddOwnerToActions < ActiveRecord::Migration
  def change
    change_table :actions do |t|
      t.references :person
    end
  end
end
