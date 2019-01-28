require 'csv'

class PayrollsController < ApplicationController
  before_action { flash.clear }

  # Displays All Processed Payrolls
  def index
    @processed_data = []
    Report.all.each do |report|
      @processed_data += report.process_report_data
    end
    @processed_data.sort_by! {|h| [h[:employee_id], h[:date_sort]]}
    flash[:notice] = "Here are all the processed payrolls." if !@processed_data.empty?
    render "payrolls/index"
  end

  # Uploads a csv file
  def upload
    csv_file = params[:csv]
    @processed_data = []
    if csv_file.blank?
        flash[:warning] = "CSV file not provided."
    else
      csv_text = csv_file.read
      if csv_text.blank?
        flash[:warning] = "CSV file content is empty. Please resubmit.s"
      else
        @report = TimeReport.parse_csv(csv_text)
        if @report 
          flash[:notice] = "File was successfully processed. Here is payroll report for payroll id #{@report.id}"
          @processed_data = @report.process_report_data 
        else
          flash[:error] = 'ERROR: This report has already been processed, re-submit not allowed.'
        end
      end
    end
    render "payrolls/index"
  end
end
