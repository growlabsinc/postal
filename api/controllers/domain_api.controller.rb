controller :domains do
    friendly_name "Domains API"
    description "This API allows you to access message details"
    authenticator :server
  
    action :verify do
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
      param :domain, "The domain to add", :type => String, :required => true
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

    action :delete do
      title "Deletes a domain"
      description "Deletes a domain on the mail server"
      param :domain, "The domain to delete", :type => String, :required => true
      returns Hash, :structure => :domain, :structure_opts => {:paramable => {:expansions => false}}
      error 'DomainNotFound', "No matching domain found", :attributes => {:domain => "The domain to verify."}
      error 'CouldNotDeleteDomain', "Could not delete domain", :attributes => {:domain => "The domain to delete."}
      action do
        begin
          domain = Domain.find_by_name(params.domain)
          if domain.nil?
            error 'DomainNotFound', :id => params.domain
          end
          domain.destroy
          { "deleted" => domain.destroyed? }
        end
      end
    end
  end
