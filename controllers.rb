def should_require_authentication_on_private_actions
  include Devise::TestHelpers

  context "without a logged user" do
    describe "GET index" do
      it "should return 200 as the status code" do
        get :index
        response.code.should eql("200")
      end
    end

    describe "GET new" do
      it "should return 302 as the status code"  do
        get :new
        response.code.should eql("302")
      end
    end

    describe "POST create" do
      it "should return 302 as the status code"  do
        post :create
        response.code.should eql("302")
      end
    end

    describe "GET edit" do
      it "should return 302 as the status code"  do
        get :edit, :id => 30
        response.code.should eql("302")
      end
    end

    describe "PUT update" do
      it "should return 302 as the status code"  do
        put :update, :id => 10
        response.code.should eql("302")
      end
    end

    describe "DELETE destroy" do
      it "should return 302 as the status code" do
        delete :destroy, :id => 20
        response.code.should eql("302")
      end
    end
  end
end

def should_require_authentication
  include Devise::TestHelpers

  context "without a logged user" do
    describe "GET index" do
      it "should return 302 as the status code"  do
        get :index
        response.code.should eql("302")
      end
    end
  end

  context "with a logged user" do
    before :each do
      sign_in Factory(:user)
    end

    describe "GET index" do
      it "should return 200 as the status code"  do
        get :index
        response.code.should eql("200")
      end
    end
  end
end

def should_require_admin_authentication
  include Devise::TestHelpers

  context "with a logged user" do
    before :each do
      sign_in Factory(:user)
    end

    describe "GET index" do
      it "should return 302 as the status code"  do
        get :index
        response.code.should eql("302")
      end
    end
  end

  context "with a logged admin" do
    before :each do
      sign_in Factory(:admin)
    end

    describe "GET index" do
      it "should return 200 as the status code"  do
        get :index
        response.code.should eql("200")
      end
    end
  end
end

def should_require_admin_authentication_on_private_actions
  include Devise::TestHelpers

  context "with a logged user" do
    before :each do
      sign_in Factory(:user)
    end

    describe "GET index" do
      it "should return 200 as the status code" do
        get :index
        response.code.should eql("200")
      end
    end

    describe "POST create" do
      it "should return 302 as the status code"  do
        post :create
        response.code.should eql("302")
      end
    end

    describe "PUT update" do
      it "should return 302 as the status code"  do
        put :update, :id => 10
        response.code.should eql("302")
      end
    end

    describe "DELETE destroy" do
      it "should return 302 as the status code" do
        delete :destroy, :id => 20
        response.code.should eql("302")
      end
    end

    describe "GET new" do
      it "should return 302 as the status code" do
        get :new
        response.code.should eql("302")
      end
    end

    describe "GET edit" do
      it "should return 302 as the status code" do
        get :edit, :id => 10
        response.code.should eql("302")
      end
    end
  end
end

def should_have_only_public_actions
  %w(index show).each do |action|
    it "should respond to GET #{action}" do
      subject.should respond_to(action)
    end
  end

  %w(edit update destroy).each do |action|
    it "should not respond to #{action}" do
      subject.should_not respond_to(action)
    end
  end
end

def without_a_logged_user(&block)
  context "without a logged user" do
    instance_eval &block
  end
end

def with_a_logged_user(&block)
  include Devise::TestHelpers

  context "with a logged user" do
    let(:user) { Factory :user }

    before :each do
      sign_in user
    end

    instance_eval &block
  end
end

def post_create_should_set_the_current_user_as_the_owner
  describe "POST create" do
    it "should set the current user as the owner" do
      model = described_class.to_s.gsub("Controller", "").underscore.singularize
      params = Factory.build(model, :user_id => Factory(:user).id).attributes
      post :create, model => params
      assigns(model.to_sym).user.should == user
    end
  end
end

def should_respond_to_js
  it "should respond as javascript" do
    association = described_class.to_s.gsub("Controller", "").underscore
    model = association.split("/").last.singularize
    params = Factory.build(model).attributes
    post :create, model => params, :format => :js
    response.should render_template("#{association}/create")
  end
end
