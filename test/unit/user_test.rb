require 'test_helper'

class UserTest < ActiveSupport::TestCase

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
		user = User.new
		user.profile_name = "My  profilename"

		assert !user.save
		assert !user.errors[:profile_name].empty?
		assert user.errors[:profile_name].include?("must be formatted correctly.")
	end 

end
