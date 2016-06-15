require 'nokogiri'
require 'pry'
require 'open-uri'
require 'colorize'
require 'json'

class Hash
  def to_xml
    map do |k, v|
      text = Hash === v ? v.to_xml : v
      "<%s>%s</%s>" % [k, text, k]
    end.join
  end
end

class Listing
  attr_accessor :id,:address,:apt,:city,:province,:post_code,:price,:lease_type,:tax,:current_year,:SPIS,
  :last_status,:DOM,:apt_type,:property_type,:unit_number,:corp_number,:locker_numer,
  :level,:rooms,:bed_rooms,:washrooms,:cross_streets,:prop_management,:fronting_on,:lot,
  :kitchens, :basement, :heat, :A_C, :garage, :park_spaces
end

class Main 
  
  def self.begin(argv)
    # html_file = open(argv[0])
    doc = Nokogiri::HTML(File.open('./index.html'))
    object = []
    object_two = []
    object_three = Array.new
    object_four = Array.new

    doc.css('div[style*="width:500px"] span span').each_with_index{|v,i| object << v.inner_text}


    puts object_three[12]
    index = 0 
    i = 0
    j = 0
    z=0
    num = 1
    arr = []
    object_num = 0
    while(index < object.length) do
        if object[index+6].downcase == "lease"
            doc.css('div[style*="width:232px"] span span').each_with_index{|v,i| object_two << v.inner_text}
            doc.css('div[style*="width:266px"] span span').each_with_index{|v,i| object_three << v.inner_text}
            doc.css('div[style*="width:252px"] span span').each_with_index{|v,i| object_four << v.inner_text}
          listing = Listing.new
          listing.id = num
          listing.address = object[index]
          listing.apt = object[index+1]
          listing.city = object[index+2]
          listing.province = object[index+3]
          listing.post_code = object[index+4]
          listing.price = object[index+5]
          listing.lease_type = object[index+6]
          listing.SPIS = object[index+11]
          listing.last_status = object[index+12]
          listing.DOM = object[index+13]
          listing.apt_type =object[index+14]
          listing.property_type = object[index+15]
          listing.unit_number = object[index+16]
          listing.corp_number = object[index+17]
          listing.locker_numer =object[index+18]
          listing.level = object[index+19]
          listing.rooms = object[index+20]
          listing.bed_rooms = object[index+21]
          listing.washrooms = object[index+22]
          listing.cross_streets = object[index+24]
          listing.prop_management = object[index+25]

          listing.kitchens=object_two[i]
          listing.basement = object_two[i+2]
          listing.heat = object_two[i+4]
          listing.A_C = object_three[j+3]
            listing.garage = object_four[z+2]
            listing.park_spaces = object_four[z+5]
            z += doc.css('div[style*="252px"]')[object_num].css('span span').count
            index += 26
            i+=12
            j+=22
            object_num += 1
        elsif object[index+6].downcase == "sale"
    doc.css('div[style*="width:262px"] span span').each_with_index{|v,i| object_two << v.inner_text}
    doc.css('div[style*="width:232px"] span span').each_with_index{|v,i| object_three << v.inner_text}
          listing = Listing.new
          listing.id = num
          listing.address = object[index]
          listing.apt = object[index+1]
          listing.city = object[index+2]
          listing.province = object[index+3]
          listing.post_code = object[index+4]
          listing.price = object[index+5]
          listing.lease_type = object[index+6]
          listing.tax = object[index+11]
          listing.current_year = object[index+12]
          listing.SPIS = object[index+13]
          listing.last_status = object[index+14]
          listing.DOM = object[index+15]
          listing.apt_type =object[index+16]
          listing.property_type = object[index+17]
          listing.lot = object[index+18]
          listing.corp_number = object[index+19]
          listing.fronting_on =object[index+20]
          listing.level = object[index+21]
          listing.rooms = object[index+22]
          listing.bed_rooms = object[index+23]
          listing.washrooms = object[index+24]
          listing.cross_streets = object[index+26]
          listing.prop_management = object[index+27]

          listing.kitchens=object_two[i]
          listing.basement = object_two[i+2]
          listing.heat = object_two[i+4]
          listing.A_C = object_two[i+5]
          listing.garage = object_three[j+2]
          listing.park_spaces = object_three[j+3]

          index += 27
            i+=14
            j+=10
        end
      arr << listing
      num += 1
    end
    i=0
    new_arr = []
    while(i<arr.length) do
      hash = arr[i].instance_variables.each_with_object({}) { |var, hash| hash[var.to_s.delete("@")] = arr[i].instance_variable_get(var) }
      new_arr << hash.to_xml
      i=i+1
    end
    puts new_arr.to_s
 
    File.open("output.txt", "a") {|f| f.write(new_arr) }
  end

end
argv = ARGV
Main.begin(argv)