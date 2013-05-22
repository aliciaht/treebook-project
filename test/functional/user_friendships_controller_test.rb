require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
		context "#index" do 
			context "when not logged in" do 
				should "redirect to login page" do 
					get :index
					assert_response :redirect 
				end
			end 

			context "when logged in" do 
				setup do 
					@friendship1 = UserFriendship.new(user: users(:alicia), friend: users(:mike))
					@friendship2 = UserFriendship.new(user: users(:alicia), friend: users(:tester), state: 'pending')
					sign_in users(:alicia)
					get :index 
				end

				should "get the index page without error" do 
					assert_response :success 
				end 

				should "assign user_friendship variable" do 
					assert assigns(:user_friendships)
				end 

				# should "display friends' names" do 
				# 	assert_match /Mike/, response.body
				# 	assert_match /Tester_First/, response.body 
				# end 

			end 

		end 

		context "#new" do 
			context "when not logged in" do 
				should "redirect to login page" do 
					get :new
					assert_response :redirect 
				end
			end 

			context "when logged in" do 
				setup do
					sign_in users(:alicia) 
				end 

				should "get new and return success" do 
					get :new
					assert_response :success
				end

				should "should set a flash error if friend_id param is missing" do 
					get :new, {}
					assert_equal "Friend required", flash[:error] 
				end 

				should "display friend's name" do 
					get :new, friend_id: users(:mike)
					assert_match /#{users(:mike).full_name}/, response.body
				end 

				should "assign a new user friendship" do 
					get :new, friend_id: users(:mike)
					assert assigns(:user_friendship)
				end 

				should "assign a new user friendship that matches" do 
					get :new, friend_id: users(:mike)
					assert_equal users(:mike), assigns(:user_friendship).friend
				end 

				should "return a 404 status if no friend is found" do 
					get :new, friend_id: 'invalid'
					assert_response :not_found 
				end 

				should "check if they really want to friend someone" do 
					get :new, friend_id: users(:mike)
					assert_match /Do you really want to friend #{users(:mike).full_name}?/, response.body
				end 

				should "calling to_param on a user returns the profile name" do 
					assert_equal "mikethefrog", users(:mike).to_param
				end 
			end
		end 

		context "#create" do 
			context "when not logged in" do 
				should "redirect to the login page" do 
					get :new
					assert_response :redirect
					assert_redirected_to login_path
				end
			end 

			context "when logged in" do 
				setup do 
					sign_in users(:alicia)
				end

				context "with no friend_id" do 
					setup do 
						post :create
					end 	

					should "set the flash error message" do 
						assert !flash[:error].empty?
					end 

					should "redirect to site root" do 
						assert_redirected_to root_path
					end 
				end

			context "successfully " do 
				should "create two user friendship objects" do 
					assert_difference 'UserFriendship.count', 2 do 
						post :create, user_friendship: { friend_id: users(:mike).profile_name }
					end 
				end 
			end 


				context "with a valid friend_id" do 
					setup do
						post :create, user_friendship: {friend_id: users(:mike)}
					end 

					should "assign a friend object" do 
						assert assigns(:friend)
						assert_equal users(:mike), assigns(:friend)
					end 

					should "assign a user_friendship object" do 
						assert assigns(:user_friendship)
						assert_equal users(:alicia), assigns(:user_friendship).user 
						assert_equal users(:mike), assigns(:user_friendship).friend
					end 

					should "create a friendship" do 
						assert users(:alicia).pending_friends.include?(users(:mike))
					end 

					should "redirect to the profile page of the friend" do 
						assert_response :redirect
						assert_redirected_to profile_path(users(:mike))
					end 

					should "set the flash success message" do 
						assert flash[:success]
						assert_equal "Friend request sent.", flash[:success]
					end 

				end
			end
		end

				context "#accept" do 
					context "when not logged in" do 
						should "redirect to login page" do 
							put :accept, id: 1
							assert_response :redirect 
							assert_redirected_to login_path
						end
					end 

					context "when logged in" do 
						setup do 
							@user_friendship = create(:pending_user_friendship, user: users(:alicia))
							sign_in users(:alicia)
							put :accept, id: @user_friendship
							@user_friendship.reload 
						end 

						should "assign a user friendship" do 
							assert assigns(:user_friendship)
							assert_equal @user_friendship, assigns(:user_friendship)
						end 

						should "update the state to accepted" do 
							assert_equal 'accepted', @user_friendship.state
						end 

						should "have a flash success message" do 
							assert_equal "You are now friends with #{@user_friendship.friend.first_name}", flash[:success]
						end 

					end 

				end 

				context "#edit" do 
					context "when not logged in" do 
						should "redirect to login page" do 
							get :edit, id: 1
							assert_response :redirect 
						end
					end 

					context "when logged in" do 
						setup do
							@user_friendship = create(:pending_user_friendship, user: users(:alicia))
							sign_in users(:alicia) 
							get :edit, id: @user_friendship
						end 

						should "get edit and return success" do 
							assert_response :success
						end

						should "assign to user_friendship object" do 
							assert assigns(:user_friendship) 
						end 

						should "assign to friend object" do 
							assert assigns(:friend) 
						end 
					end 
				end 
	end