require_relative 'ec2_find_base'
module EC2Find
  class Ec2findImage < Ec2findBase

    banner "knife ec2find image TAGS"

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
      ["image_id", "image_location", "state", "public", "architecture", "image_type", "platform", "name", "description", "root_device_type", "virtualization_type", "hypervisor", "tags"]
    end

    def findby tags
      ec2connect
      @ec2client.describe_images({dry_run: false, filters: tags}).images
    end

  end
end
