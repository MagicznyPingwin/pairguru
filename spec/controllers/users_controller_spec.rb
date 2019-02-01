require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #ranking" do
    it "returns http success" do
      get :ranking
      expect(response).to have_http_status(:success)
    end
  end

end
