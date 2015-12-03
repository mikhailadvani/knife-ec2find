require_relative 'ec2_find_base'
module EC2Find
  class Ec2findSg< Ec2findBase

    banner "knife ec2find sg TAGS"

    option :tags,
           :short => "-T T=V[,T=V[,T=V...]]",
           :long => "--tags Tag=Value[,Tag=Value[,Tag=Value...]]",
           :description => "Lists instances created with set of tags"

    option :aws_access_key_id,
           :long => "--aws-access-key-id KEY",
           :description => "Your AWS Access Key ID"

    option :aws_secret_access_key,
           :short => "-K SECRET",
           :long => "--aws-secret-access-key",
           :description => "Your AWS API Secret Access Key"

    option :projection,
           :short => "-a ATTRIBUTES",
           :long => "--attributes",
           :description => "To project only required attributes"

    option :suppress_attribute_names,
           :long => "--suppress-attribute-names",
           :description => "Print only entity description attribute values and no keys",
           :boolean => true,
           :default => false


    private
    def default_attributes
      ["group_name","group_id","description","ip_permissions","ip_permissions_egress","vpc_id","tags"]
    end

    def findby tags
      ec2connect
      x = @ec2client.describe_security_groups({dry_run: false, filters: tags}).security_groups
      puts x.inspect
      x
    end

  end
end
