require "uri"
require "net/http"
require "csv"

RANGE = 1..200

list = []

RANGE.each do |x|
    url = URI("https://www.abuseipdb.com/sitemap?page=#{x}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    request["Cookie"] = "XSRF-TOKEN=eyJpdiI6IkJ2b0tQME5WMDdZdnVWa25jSG9JNWc9PSIsInZhbHVlIjoiWit3Y0ZpZ0Y2dmE1YURrbkZOa1k3YUJ2R2VkTXBZbVVianFUcU1lMzdHclkybVFhSW1nZDJuQXh3WitqeEppeiIsIm1hYyI6IjJjZDNiMTQxODUzY2RlZTM5MGJmN2JjZDI1NjAxYzZiMmY0NDg3ZmYwYmI2OTY2ZGQwZWU3YzAzZjEzMjE2ZmEifQ%3D%3D; abuseipdb_session=eyJpdiI6IkhncVJcL1Vrd1hwcmFOTTYzVTV6NmpRPT0iLCJ2YWx1ZSI6ImQyWGJVWTZSR29Lakkxais4K2x0Z0RuM01CXC9CRWQ2YzhKMkdYVWtGWE94YWJVKyt2YnlyUWNSR2g4d291UzJzIiwibWFjIjoiM2Y2ZThmNGE4MDAyZmFjNDBjNzBjYzAzMDg4Y2MzYTk4MzUxNWE2MTVhYTQzN2I2M2FiZTViZTBkYWZjZDY1NyJ9"
    response = https.request(request)
    a = response.read_body.to_s.scan(/(?:check)\/(.*?)"/)
    list.concat(a)
    puts "Pulled data from page=#{x} successfully."
end

puts
puts "Writing array to csv file..." 
puts

headers = ["ip"]
CSV.open("data_collected/abuseipdb/abuseipdb_ip_list.csv", "w", :col_sep => "\t| ", :headers => true) do |csv|
    csv << headers
    list.each do |row| 
        csv << row
    end    #Adding rows for each element of a
end

puts "Process completed!"