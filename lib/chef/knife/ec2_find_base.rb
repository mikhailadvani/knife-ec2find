require 'chef/knife'
require 'aws-sdk'

module EC2Find
  class Ec2findBase < Chef::Knife

    def run
      if validated?
        resources = findby tag_filters
        resources.each do |resource|
          if config[:projection]
            print_description resource, config[:projection].split(",")
          else
            print_description resource
          end
        end
        ui.msg("#{resources.size} resource(s) found") unless config[:suppress_attribute_names]
      end
    end

    private

    def print_description resource, attributes=default_attributes
      begin
        attributes.each do |attribute|
          unless config[:suppress_attribute_names]
            puts "#{attribute}\t#{resource.send(attribute)}"
          else
            puts "#{resource.send(attribute)}"
          end
        end
      rescue Exception => e
        ui.error("Please check the attribute name(s) needed")
        exit(1)
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

    def ec2connect
      begin
        @ec2client = Aws::EC2::Client.new(access_key_id: config[:aws_access_key_id], secret_access_key: config[:aws_secret_access_key])
      rescue Aws::Errors::MissingRegionError => e
        ui.error("Please provide AWS region as an enviroment variable")
        exit(1)
      end
    end
  end
end
