controller :domains do
    friendly_name "Domains API"
    description "This API allows you to access message details"
    authenticator :server
  
    action :check do
      title "Returns verification information about a domain"
      description "Returns the verification about a domain"
      param :domain, "The domain that you're checking", :type => String, :required => true
      returns Hash, :structure => :domain, :structure_opts => {:paramable => {:expansions => false}}
      error 'DomainNotFound', "No matching domain found", :attributes => {:domain => "The domain to verify."}
      action do
        begin
          domain = Domain.find_by_name(params.domain)
          if domain.nil?
            error 'DomainNotFound', :id => params.domain
          end
          domain.check_dns
        structure :domain, domain, :return => true
        end
      end
    end
  
    action :add do
      title "Adds a domain"
      description "Adds a domain to the mail server"
      param :domain, "The ID of the message", :type => String, :required => true
      returns Hash, :structure => :domain, :structure_opts => {:paramable => {:expansions => false}}
      error 'CouldNotAddDomain', "Could not add domain", :attributes => {:domain => "The domain to add."}
      action do
        begin
          domain = identity.server.domains.build(name: params.domain)
          if domain.nil?
            error 'DomainNotFound', :id => params.domain
          end
          domain.verification_method = 'DNS'
          domain.verified_at = Time.now
          domain.save!
          domain.check_dns
          structure :domain, domain, :return => true
        end
      end
    end
  end
