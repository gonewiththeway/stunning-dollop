class CreateJobGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :job_groups do |t|
      t.string :name
      t.integer :wage

      t.timestamps
    end
    add_index :job_groups, :name
  end
end
