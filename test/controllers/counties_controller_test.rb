require 'test_helper'

class CountiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get counties_index_url
    assert_response :success
  end

  test "should get show" do
    get counties_show_url
    assert_response :success
  end

end
