structure :domain do
    basic :id
    basic :uuid
    basic :name
    basic :dkim_record_name, :value => Proc.new { o.dkim_record_name }
    basic :dkim_record, :value => Proc.new { o.dkim_record }
    basic :dkim_status, :value => Proc.new { o.dkim_status }
    basic :spf_record, :value => Proc.new { o.spf_record }
    basic :spf_status, :value => Proc.new { o.spf_status }
    basic :return_path, :value => Proc.new { o.return_path_domain }
  end
  