require_relative 'ec2_find_base'
module EC2Find
  class Ec2findInstance < Ec2findBase

    banner "knife ec2find instance TAGS"

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
      ["instance_id", "image_id", "key_name", "subnet_id", "vpc_id", "private_ip_address", "public_ip_address", "tags"]
    end

    def findby tags
      ec2connect
      reservation = @ec2client.describe_instances({dry_run: false, filters: tags}).reservations[0]
      if reservation.nil?
        []
      else
        reservation.instances
      end
    end

  end
end
