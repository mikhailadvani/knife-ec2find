require 'chef/knife'
require 'aws-sdk'

module EC2Find
  class Ec2findBase < Chef::Knife

    def run
      @region = config[:region] || ENV["AWS_REGION"]
      @access_key_id = config[:aws_access_key_id] || ENV["AWS_ACCESS_KEY_ID"]
      @secret_access_key = config[:aws_secret_access_key] || ENV["AWS_SECRET_ACCESS_KEY"]
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

    def attribute_values resource, attribute
      attribute_hierarchy_sequence = attribute.split(".")
      container_values = resource.send(attribute_hierarchy_sequence[0])
      container_values = [container_values] unless container_values.class.eql?(Array)
      values = []
      container_values.each do |container_value|
        if attribute_hierarchy_sequence.length == 1
          values << container_value
        else
          values << attribute_values(container_value, attribute_hierarchy_sequence[1..(attribute_hierarchy_sequence.length - 1)].join("."))
        end
      end
      values
    end

    def format_values values
      if values[0].class.eql?(Array)
        formatted_values = values.join(",")
        return formatted_values
      else
        formatted_values = []
        values.each do |struct_value|
          struct_value.to_hash.each do |k, v|
            formatted_values << "#{k}=\"#{v}\""
          end
        end
        return formatted_values.join(",")
      end
    end
    def print_description resource, attributes=default_attributes
      begin
        attributes.each do |attribute|
          values = format_values(attribute_values(resource, attribute))
          unless config[:suppress_attribute_names]
            puts "#{attribute}\t#{values}"
          else
            puts "#{values}"
          end
        end
      rescue Exception => e
        ui.error("Please check the attribute name(s) needed")
        exit(1)
      end
    end

    def validated?
      ui.error("Please provide region") if @region.nil?
      ui.error("Please provide access key id") if @access_key_id.nil?
      ui.error("Please provide secret access key") if @secret_access_key.nil?
      ui.error("Please specify the selector tags") if config[:tags].nil?
      !@region.nil? && !@access_key_id.nil? && !@secret_access_key.nil? && !config[:tags].nil?
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
        @ec2client = Aws::EC2::Client.new(access_key_id: @access_key_id, secret_access_key: @secret_access_key, region: @region)
      rescue Exception => e
        ui.error(e.message)
        exit(1)
      end
    end
  end
end
