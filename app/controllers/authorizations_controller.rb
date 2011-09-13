require 'oauth2'
require 'sales_force'
require 'yaml'

class AuthorizationsController < ApplicationController
  before_filter :check_token, :except => [:access_token, :callback]

  def access_token
    client = SalesForce::Authentication.client
    redirect_to client.web_server.authorize_url(
      :response_type => "code",
      :redirect_uri => "https://fb-recruiting.heroku.com/authorizations/callback"
    )
  end

  def callback
    client = SalesForce::Authentication.client
    access_token = client.web_server.get_access_token(params[:code], 
                                                      :redirect_uri => "https://fb-recruiting.heroku.com/authorizations/callback", 
                                                      :grant_type => "authorization_code")

    $sales_force = OAuth2::AccessToken.new(client, 
                                           access_token['access_token'], 
                                           access_token.refresh_token, 
                                           (60 * 60 * 2),
                                           access_token)
    #you can remove this one
    $refresh_token = access_token.refresh_token

    redirect_to :controller => 'pages', :action => 'refresh_token', :refresh_token => access_token.refresh_token
  end
end
