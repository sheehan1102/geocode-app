# == Schema Information
#
# Table name: locations
#
#  id                  :integer          not null, primary key
#  address_one         :string           not null
#  address_two         :string           not null
#  city                :string           not null
#  state               :string           not null
#  zip                 :string           not null
#  country             :string
#  lat                 :string
#  long                :string
#

class Location < ActiveRecord::Base
  validates_presence_of :address_one, :city, :state, :zip

  scope :id_descending, ->{ order(id: :desc) }

  def full_text_address
    street_address = address_two_empty? ? "#{address_one}" : "#{address_one}, #{address_two}"
    return "#{street_address}, #{city}, #{state} #{zip}"
  end

  def full_geocode_url_address
    [address_one, city, state, zip].map{ |el| URI.escape(el) }.join(',')
  end

  def shortened(coord)
    coord = send(coord.to_sym)
    unless coord.nil?
      coord.length > 10 ? coord.slice(0, 10) : coord
    end
  end

  private

    def address_two_empty?
      address_two == '' || address_two.nil?
    end

end