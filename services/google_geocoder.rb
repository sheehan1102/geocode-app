class GoogleGeocoder

  def self.call(*args)
    self.new(*args).call
  end

  def initialize(location, preferred_format='json')
    @location         = location
    @preferred_format = preferred_format
    @base_uri         = "https://maps.googleapis.com/maps/api/geocode"
  end

  def call
    response = HTTParty.get(geocoder_api_uri)
    coords = response['results'].try(:[], 0)
                                .try(:[], 'geometry')
                                .try(:[], 'location')
    return {} if coords.nil?
    return { lat: coords['lat'].to_s, long: coords['lng'].to_s }
  end

  private

    def geocoder_api_uri
      "#{@base_uri}/#{@preferred_format}?address=#{@location.full_geocode_url_address}"
    end
end