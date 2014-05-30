require 'omniauth/strategies/oauth2'
require 'jwt'

module OmniAuth
  module Strategies
    class AzureOauth2 < OmniAuth::Strategies::OAuth2
      BASE_AZURE_URL = 'https://login.windows.net'

      option :name, 'azure_oauth2'

      option :tenant_provider, nil

      # AD resource identifier
      option :resource, '00000002-0000-0000-c000-000000000000'

      # tenant_provider must return client_id, client_secret, tenant_id
      args [:tenant_provider]

      def client
        # Fold on options from dynamic tenant provider
        options.client_id = options.tenant_provider.client_id
        options.client_secret = options.tenant_provider.client_secret
        options.tenant_id = options.tenant_provider.tenant_id

        options.client_options.authorize_url = "#{BASE_AZURE_URL}/#{options.tenant_id}/oauth2/authorize"
        options.client_options.token_url = "#{BASE_AZURE_URL}/#{options.tenant_id}/oauth2/token"

        options.token_params.resource = options.resource
        super
      end

      uid {
        raw_info['sub']
      }

      info do
        {
          name: raw_info['unique_name'],
          first_name: raw_info['given_name'],
          last_name: raw_info['family_name'],
          email: raw_info['email'] || raw_info['upn']
        }
      end


      def raw_info
        # it's all here in JWT http://msdn.microsoft.com/en-us/library/azure/dn195587.aspx
        @raw_info ||= JWT.decode(access_token.token, nil, false)
      end

    end
  end
end