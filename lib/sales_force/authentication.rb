require 'oauth2'

module SalesForce
  class Authentication
    class << self
      def refresh
        begin
          token = OAuth2::AccessToken.refresh_token client, $refresh_token
          $sales_force = OAuth2::AccessToken.new(client, token['access_token'], $refresh_token, (60 * 60 * 2), token)
        rescue => msg
          puts '==== ERROR ===='
          puts msg
          puts '==== ERROR ===='
        end
      end

      def client
        OAuth2::Client.new(
          $consumer_key, 
          $consumer_secret, 
          :site => 'https://login.salesforce.com', 
          :authorize_path =>'/services/oauth2/authorize', 
          :access_token_path => '/services/oauth2/token'
        )
      end
    end
  end
end
