class CreateTimeReports < ActiveRecord::Migration[5.2]
  def change
    create_table :time_reports, id: :integer do |t|
      t.date :date
      t.integer :hours
      t.integer :employee_id
      t.integer :report_id
      t.string :job_group_name

      t.timestamps
    end

    add_index :time_reports, :job_group_name
    add_index :time_reports, :report_id
  end
end
