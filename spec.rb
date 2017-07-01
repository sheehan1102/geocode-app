ENV['RACK_ENV'] = 'test'

require './server.rb'
require 'rspec'
require 'rack/test'
require 'pry'

describe 'DynamiCare App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:good_params) {{
    location: {
      address_one: '14 Degobah Way',
      city: 'Hoth City',
      state: 'Fed 7',
      zip: '90-92636674'
    }
  }}

  describe "GET /" do
    before do
      @location = Location.create(good_params[:location])
      @location.update_attributes(lat: '43.784637', long: '-73.39284')
    end

    after do
      Location.delete_all
    end

    subject { get '/' }

    it "returns ok status" do
      subject
      expect(last_response).to be_ok
    end

    it "contains location text" do
      subject
      %w(address_one city state zip lat long).each do |attrib|
        expect(last_response.body).to include(@location.send(attrib.to_sym))
      end
    end
  end

  describe "POST /api/locations" do
    context "when params are invalid" do
      let(:bad_params) {{
        location: {
          address_one: 'Tatooine Ave.'
        }
      }}

      subject { post '/api/locations', bad_params }

      it "does not create Location" do
        subject
        expect(last_response.status).to eq 422
      end
    end

    context "when params are valid" do
      before do
        allow(GoogleGeocoder).to receive(:call).and_return(
          {
            lat: '43.784637',
            long: '-73.39284'
          }
        )
      end

      subject { post '/api/locations', good_params }

      it "returns created status" do
        subject
        expect(last_response.status).to eq 201
      end

      it "creates new Location" do
        expect{ subject }.to change{
          Location.count
        }.by 1
      end

      it "makes call to GoogleGeocoder" do
        expect(GoogleGeocoder).to receive(:call).with(
          an_instance_of(Location)
        )
        subject
      end
    end
  end
end