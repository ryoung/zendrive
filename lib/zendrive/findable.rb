module Zendrive
  class Findable
    INDEX_ENDPOINT = nil
    SINGLE_ENDPOINT = nil
    RESOURCE_NAME = nil

    def self.all(interpolated_params = nil)
      response = RestClient.get(url_for(self::INDEX_ENDPOINT, interpolated_params), default_params)
      records = JSON.parse(response.body)[self::RESOURCE_NAME]
      records.map { |attributes| new(attributes) }
    end

    # Combine the top level API endpoint with the version and the resource specific endpoint
    def self.url_for(endpoint, interpolated_params)
      [Zendrive.endpoint, Zendrive.api_version, (interpolated_endpoint(endpoint, interpolated_params))].join("/")
    end

    # Required on all API calls
    def self.default_params
      {
        accept: :json,
        content_type: :json,
        params: { apikey: Zendrive.api_key }
      }
    end

    # Replace any parameters that need to be interpolated.
    # Ex: /driver/{driver_id}/trips -> /driver/123/trips
    def self.interpolated_endpoint(endpoint, params)
      if params
        params.each do |name, value|
          endpoint.gsub!("{#{name}}", "#{value}")
        end
      end

      endpoint
    end
  end
end