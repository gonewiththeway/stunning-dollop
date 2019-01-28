class Report < ApplicationRecord
  validates :id, presence: true

  # Payroll data processor
  def process_report_data
    # all details about this report id
    details = TimeReport.where(:report_id => self.id)

    # get distinct employee_id for this report
    employee_ids = details.map(&:employee_id).uniq

    # Job group wage
    job_group_hash = JobGroup.all.map do |job_group|
      [job_group[:name], job_group[:wage]]
    end.to_h

    payroll_report = []
    # process data from time report with this report id
    employee_ids.each do |employee_id| 
      amount_paid = 0.0
      last_report_date = Date.new

      details.each do |row|
        if row.employee_id == employee_id
          last_report_date = row.date if last_report_date < row.date
          amount_paid += _calculate_amount(row.hours, job_group_hash[row.job_group_name])
        end
      end

      payroll_report << {
        :employee_id => employee_id, 
        :pay_period => _format_pay_period(last_report_date),
        :amount_paid => amount_paid, 
        :report_id => self.id,
        :date_sort => last_report_date}
    end
    payroll_report.sort_by! {|h| [h[:employee_id], h[:date_sort]]}
  end

  private

  def _format_pay_period(last_report_date)
    date = Date.new(last_report_date.year, last_report_date.month)
    if last_report_date.day <= 15
      "#{_format_date(date)} - #{_format_date(date + 14.days)}"
    else
      "#{_format_date(date + 15.days)} - #{_format_date(date.end_of_month)}"
    end
  end

  def _format_date(date)
    date.strftime('%-d/%-m/%Y')
  end

  def _calculate_amount(hours, rate) 
    rate.to_f * hours.to_f
  end
end
