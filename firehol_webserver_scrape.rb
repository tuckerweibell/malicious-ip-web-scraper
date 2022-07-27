require 'ipaddr'
require "csv"
require "uri"
require "net/http"

list = []

url = URI("https://iplists.firehol.org/files/firehol_webserver.netset")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
request = Net::HTTP::Get.new(url)
response = https.request(request)
doc = response.read_body.to_s

puts "Starting process..."
puts
ip_addresses = doc.to_s.scan(/\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/)

puts "Pulled html file successfully!" 

ip_addresses.each do |x|
    list.append(x)
end

puts "Added IPs successfully!" 
puts


cidr_ranges = doc.to_s.scan(/\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\/\d{1,2}\b/)
puts "Starting cidr range process..."
cidr_ranges.each do |cidr_range|
    net_range = IPAddr.new(cidr_range).to_range
    net_range.each do |x|
        list.append(x)
    end
   # puts "Completed range #{cidr_range}"
end

puts
puts "Writing array to csv file..." 
puts
count = 1
list.each_slice(7000000) do |slice|
    headers = ["ip"]
    CSV.open("data_collected/webserver/firehol_webserver_list_#{count}.csv", "w", :col_sep => "\t| ", :headers => true) do |csv|
        csv << headers
        slice.each do |row| 
            temp = []
            temp.append(row)
            csv << temp
        end    #Adding rows for each element of a
    end
    count += 1
end
puts "Process completed!"
