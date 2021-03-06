require File.dirname(__FILE__) + '/../spec_helper'
require 'mocha'
 
describe UsersController do
  fixtures :all
  render_views
  
	describe "new action" do
	  it "should render new template" do
	    get :new
	    response.should render_template(:new)
	  end
	end

 	describe "create action" do
	  it "should render new template when model is invalid" do
	    User.any_instance.stubs(:valid?).returns(false)
	    post :create
	    response.should render_template(:new)
	  end
  
	  it "should redirect when model is valid" do
	    u = mock_model(User)
	    User.stub!(:new).and_return(u)
	    u.stub!(:save).and_return(true)
	    post :create
	    response.should redirect_to(root_url)
	    session['user_id'].should == assigns['user'].id
	  end
	end
	
	describe "edit action" do
		it "should display the current user data" do
			user = Factory.build(:user, :id=>1)
			session[:user_id]=user.id
			User.stub!(:find).with(user.id).and_return(user)
			get :edit
			assigns[:user].should == user
		end
	end

	describe "update action" do
		
		before :each do
			@attrs = Factory.attributes_for(:user)
			@user = User.new(@attrs)
			@user.id = 1
			User.stub!(:find).and_return(@user)
  		session[:user_id] = @user.id
		end
		
		it "should render the edit template again" do
			put :update, :user=>@attrs, :id=>@user.id
			response.should redirect_to(edit_profile_path)
		end
		
		it "should show a success message" do
			put :update, :user=>@attrs, :id=>@user.id
			flash[:notice].should == "Profile successfully updated!"
		end
		
		it 'should update the user' do
			# user = mock_model(User)
			User.should_receive(:find).with(@user.id).and_return(@user)
			@user.should_receive(:update_attributes).with(@attrs.stringify_keys)
			put :update, :user=>@attrs, :id=>@user.id
		end
		
		describe "with invalid user" do
			
			before :each do
				@user.stub!(:valid?).and_return(false)
			end
			
			it "should render the edit templage again" do
				put :update, :user=>@attrs, :id=>@user.id
				response.should render_template(:edit)
			end

			it "should have no flash notice" do
				put :update, :user=>@attrs, :id=>@user.id
				flash[:notice].should be_nil
			end

		end

		
	end

	describe "index action" do
	  
	  before :each do
	    @attrs = Factory.attributes_for(:user)
			@user = User.new(@attrs)
			@user.id = 1
			User.stub!(:all).and_return([@user])
			User.stub!(:find).and_return(@user)
  		session[:user_id] = @user.id
    end

	  it "should render index template" do
	    get :index
	    response.should render_template(:index)
	  end

	  it "should find all users" do
			my_array = [Factory.create(:user),Factory.create(:user)]
			User.should_receive(:all).and_return(my_array)
	    get :index
			assigns[:users].should == my_array
	  end

	end
	
end

