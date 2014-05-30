# OmniAuth Windows Azure Active Directory Strategy WAAD

This gem provides a simple way to authenticate to Windows Azure Active Directory (WAAD) over OAuth2 using OmniAuth.

One of the unique challenges of WAAD OAuth is that WAAD is multi tenant. Any given tenant can have multiple active
directories. The CLIENT-ID, REPLY-URL and keys will be unique to the tenant/AD/application combination. This gem simply
provides hooks for determining those unique values for each call.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-azure-auth2'
```

## Usage

First, you will need to add your site as an application in WAAD.:
[Adding, Updating, and Removing an Application](http://msdn.microsoft.com/en-us/library/azure/dn132599.aspx)

Summary:
Select your Active Directory in https://manage.windowsazure.com/<tenantid> of type 'Web Application'. Name, sign-on url,
logo are not important.  You will need the CLIENT-ID from the application configuration and you will need to generate
an expiring key (aka 'client secret').  REPLY URL is the oauth redirect uri.
The APP ID UI just needs to be unique and identify your site and isn't needed to configure the gem.
Permissions need Delegated Permissions to at least have "Enable sign-on and read user's profiles".
Note: Seems like the terminology is still fluid, so follow the MS guidance (buwahaha) to set this up.

```ruby
use OmniAuth::Builder do
  provider :azure, YourTentProvider
end
```

The TenantProvider class must provide client_id, client_secret and tenant_id. For a simple single-tenant app, this could be:

```ruby
class YouTenantProvider
  def self.client_id
    ENV['AZURE_CLIENT_ID']
  end

  def self.client_secret
    ENV['AZURE_CLIENT_SECRET']
  end

  def self.tenant_id
    ENV['AZURE_TENANT_ID']
  end
end
```

## Auth Hash Schema

The following information is provided back to you for this provider:

```ruby
{
  uid: '12345',
  info: {
    name: 'some one', # may be email
    first_name: 'some',
    last_name: 'one',
    email: 'someone@example.com'
  },
  credentials: {
    token: 'thetoken', # can be used to auth to the API
    refresh_token: 'refresh' # can be used refresh the token
  },
  extra: { raw_info: raw_api_response }
}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes and tests  (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
