require 'test_helper'

class PayrollsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get payrolls_index_url
    assert_response :success
  end

  test "should get upload" do
    get payrolls_upload_url
    assert_response :success
  end

end
