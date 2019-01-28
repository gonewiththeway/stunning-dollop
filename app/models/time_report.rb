class TimeReport < ApplicationRecord
  validates :date, presence: true 
  validates :hours, presence: true 
  validates :employee_id, presence: true 
  validates :job_group_name, presence: true 
  validates :report_id, presence: true 

  # Parses a csv file and retuns a report object
  def self.parse_csv(csv_text)
    rows = []
    report = nil

    CSV.parse(csv_text).each_with_index do |row, row_num|
      # skipping the header row
      next if row_num == 0
      first_col = row[0] 

      # check if last line in the csv
      if first_col == "report id"
        report = _add_rows_to_db(rows, row[1].to_i)
      else
        rows << {
          :date => Date.parse(first_col), 
          :hours => row[1].to_i, 
          :employee_id => row[2].to_i, 
          :job_group_name => row[3].strip}
      end
    end
    report
  end

  private

  def self._add_rows_to_db(rows, report_id)
    # Not let this create a duplicate report 
    # TO-DO make this an exception
    return nil if Report.where(:id => report_id).exists?

    # Adding report_id to each employee report
    rows.each {|row| row[:report_id] = report_id}
    TimeReport.transaction do
      TimeReport.create!(rows)
      Report.create!({:id => report_id})
    end
  end
end
