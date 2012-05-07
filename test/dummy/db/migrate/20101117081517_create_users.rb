class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.integer :rank
      t.float :factor
      t.date :activated_on
      t.text :biography
      t.boolean :admin
      t.integer :group_id

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
