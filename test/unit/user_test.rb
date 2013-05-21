require 'test_helper'

class UserTest < ActiveSupport::TestCase

	should have_many (:user_friendships)
	should have_many (:friends)

	test "a user should enter a first name" do 
		user = User.new
		assert !user.save
		assert !user.errors[:first_name].empty?
	end

	test "a user should enter a last name" do 
		user = User.new
		assert !user.save
		assert !user.errors[:last_name].empty?
	end

	test "a user should enter a profile name" do 
		user = User.new
		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	test "user should have unique proflile name" do
		user = User.new
		user.first_name = 'Alicia'
		user.last_name = 'Tan'
		user.email = 'aliciaht@gmail.com'
		user.password = 'password'
		user.password_confirmation = 'password'
		user.profile_name = 'Alicia'

		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	test "profile name should not have spaces" do
		user = User.new(first_name: 'Alicia', last_name: "Tan", email: 'aliciat@gmail.com')
		user.password = user.password_confirmation = 'asdfasdf'
		user.profile_name = "My  profilename"
		assert !user.valid?
	end 

	test "profile name without spaces is ok" do
		user = User.new(first_name: 'Alicia', last_name: "Tan", email: 'aliciat@gmail.com')
		user.password = user.password_confirmation = 'asdfasdf'
		user.profile_name = "profilename"
		assert user.valid?
	end 

	test "no error raised when accessing a friend list" do 
		assert_nothing_raised do 
			users(:alicia).friends 
		end
	end

	test "creating friendships on a user works" do 
		users(:alicia).friends << users(:mike)
		users(:alicia).friends.reload
		assert users(:alicia).friends.include?(users(:mike))
	end 

	test "calling to_param on a user returns profile name"
		assert_equal "Alicia", users(:alicia).to_param
	end 


end
