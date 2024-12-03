require_relative './download_request.rb'
require_relative '../helpers/color.rb'
class CSRDataInventory
  def self.download
    puts "Please enter your token:"
    token = gets.strip
    download_url = "https://datascience.uth.edu/medcis/databases/download_file_list?"
    params_part = URI.encode_www_form([["token",token]])
    download_url = download_url + params_part
    download_folder = download_folder = ::File.join(Dir.pwd, "#{token}_file_list.txt")
    download_request = DownloadRequest.new(download_url, download_folder)
    download_request.get
    if download_request.error.to_s == ""
    	puts "  File list downloaded"
    	File.readlines("#{Dir.pwd}/#{token}_file_list.txt").each do |line|
    		path_tokens = line.strip.split

    		path = path_tokens[0]
    		file_size = path_tokens[1]
    		 
    		puts "    Downloading file: #{path}".bg_gray.blue
    		download_url = "https://datascience.uth.edu/medcis/databases/download_file?"
		    params_part = URI.encode_www_form([["token",token], ["path", path]])
		    download_url = download_url + params_part
		    download_folder = ::File.join(Dir.pwd, path[14..-1])
		    if File.exists?(download_folder) and (File.size(download_folder).to_s == file_size)
		    	puts "    File exists".white
		    	next
		    end
		    download_request = DownloadRequest.new(download_url, download_folder)
		    download_request.get
	      if download_request.error.to_s == ""
	      	puts "    Successful".green
	      else
	      	puts "    Failed: #{download_request.error.to_s}".red
	      end
    	end;nil
    else
    	puts "  #{download_request.error.to_s}".red
    end
  rescue
    puts "\nINTERRUPTED".red
  end
end