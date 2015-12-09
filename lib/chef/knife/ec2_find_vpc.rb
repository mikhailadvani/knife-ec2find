require_relative 'ec2_find_base'
module EC2Find
  class Ec2findVpc < Ec2findBase

    banner "knife ec2find vpc TAGS"

    option :tags,
           :short => "-T T=V[,T=V[,T=V...]]",
           :long => "--tags Tag=Value[,Tag=Value[,Tag=Value...]]",
           :description => "Lists vpcs created with set of tags"

    option :aws_access_key_id,
           :long => "--aws-access-key-id KEY",
           :description => "Your AWS Access Key ID(fallback to environment variable - AWS_ACCESS_KEY_ID)"

    option :aws_secret_access_key,
           :short => "-K SECRET",
           :long => "--aws-secret-access-key",
           :description => "Your AWS API Secret Access Key(fallback to environment variable - AWS_SECRET_ACCESS_KEY)"

    option :region,
           :long => "--region REGION",
           :description => "AWS Region your VPC is hosted in(fallback to environment variable - AWS_REGION)"

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
      ["vpc_id", "cidr_block", "instance_tenancy", "is_default", "tags"]
    end

    def findby tags
      ec2connect
      @ec2client.describe_vpcs({dry_run: false, filters: tags}).vpcs
    end

  end
end
