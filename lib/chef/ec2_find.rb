require 'chef/knife'
require 'aws-sdk'
module EC2Find
  class Ec2findInstance < Chef::Knife

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

    def run
      if validated?
        instances = findby tag_filters
        instances.each do |instance|
          if config[:projection]
            print_description instance, config[:projection].split(",")
          else
            print_description instance
          end
        end
      end
    end

    private
    def default_attributes
      ["instance_id", "image_id", "key_name", "subnet_id", "vpc_id", "private_ip_address", "public_ip_address", "tags"]
    end

    def print_description instance, attributes=default_attributes
      begin
        attributes.each do |attribute|
          unless config[:suppress_attribute_names]
            puts "#{attribute}\t#{instance.send(attribute)}"
          else
            puts "#{instance.send(attribute)}"
          end
        end
      rescue Exception => e
        puts e.message
        ui.error("Please check the attribute name")
      end
    end

    def validated?
      ui.error("Please provide access key id") if config[:aws_access_key_id].nil?
      ui.error("Please provide secret access key") if config[:aws_secret_access_key].nil?
      ui.error("Please specify the selector tags") if config[:tags].nil?
      !config[:aws_access_key_id].nil? && !config[:aws_secret_access_key].nil? && !config[:tags].nil?
    end

    def tag_filters
      tags = []
      config[:tags].split(",").each do |tag|
        key, value = tag.split("=")
        tags << {name: "tag:#{key}", values: [value]}
      end
      tags
    end

    def findby tags
      @ec2client = Aws::EC2::Client.new(access_key_id: config[:aws_access_key_id], secret_access_key: config[:aws_secret_access_key])
      @ec2client.describe_instances({dry_run: false, filters: tags}).reservations[0].instances
    end
  end
end
