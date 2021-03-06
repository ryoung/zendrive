module Zendrive
  class Driver < Findable
    INDEX_ENDPOINT = "drivers"
    SINGLE_ENDPOINT = "driver"
    RESOURCE_NAME = "drivers"

    attr_reader :id, :driver_id, :info, :rank, :score, :recommendation

    def initialize(attributes)
      @id = attributes["driver_id"]
      @driver_id = attributes["driver_id"]
      @info = Util::DeepStruct.new(attributes["info"])
      @rank = attributes["rank"]
      @score = Util::DeepStruct.new(attributes["score"])
      @recommendation = attributes["recommendation"]
    end

    def self.find(id)
      params = default_params.dup
      params[:params].merge!({ids: id})

      response = RestClient.get(url_for(self::INDEX_ENDPOINT, {}), params)
      drivers = JSON.parse(response.body)
      if drivers && drivers["drivers"] && drivers["drivers"].length > 0
        new(drivers["drivers"].first)
      end
    end

    def trips(params = {})
      Trip.all({driver_id: id}, params)
    end

    def score(params = {})
      Score.find(@id, params)
    end
  end
end
