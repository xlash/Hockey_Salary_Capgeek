require 'rubygems'
require 'mechanize'
require 'json'

a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}


require 'csv'    

csv_text = File.read('liste_attaquants3.csv')
csv = CSV.parse(csv_text, :headers => false)
csv.each do |row|
  name_array = row[1].split(" ")
  name_array
  a.get('http://capgeek.com/scripts/autosearch.php?maxRows=15&name_startsWith='+name_array.last) do |page|
	  x = JSON.parse(page.content)
	  for player in x["players"]
	  	  #puts "Player => " + " " + name_array.last + " " + name_array.first
	  	  if player["FIRST_NAME"] == name_array.first
			  begin
			  	full_page = a.get('http://capgeek.com/player/'+ player["ID"])
			  	cap = full_page.at('div.infobox-caphit').content.split( /\r?\n/)[1].split('$')[1].gsub(',','')
			  	puts "\t " + player["ID"] + " " + row[7] + "pts " + player["LAST_NAME"] + " " + player["FIRST_NAME"] + " " + cap.to_s + " " 
			  	break
			  rescue
			  	puts "error "
			  end
		  end
	  end	  
  end
end

