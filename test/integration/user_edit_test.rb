require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  #Define @user as the user Michael Example from test/fixtures/users.yml
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    #Go the the edit page for the user defined as @user
    get edit_user_path(@user)
    #Confirm the the template for editing users is loaded
    assert_template 'users/edit'
    #Request an edit of the user with invalid parameters
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
    #Confirm that no attributes have changed
    @user.reload
    assert @user.attributes == users(:michael).attributes
    #Confirm that we are still on the editing users page
    assert_template 'users/edit'
  end
  
  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
  
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
