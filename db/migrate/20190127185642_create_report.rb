class CreateReport < ActiveRecord::Migration[5.2]
  def change
    create_table :reports, id: :integer do |t|
      t.timestamps
    end
  end
end
