require 'sales_force'

class ApplicationController < ActionController::Base
  before_filter :check_token

  private
    def check_token
      unless $refresh_token.nil?
        if $sales_force.nil?
          SalesForce::Authentication.refresh
        elsif $sales_force.expires_at < Time.now
          SalesForce::Authentication.refresh
        end
      else
        redirect_to :controller => 'authorizations', :action => 'access_token'
      end
    end
end
