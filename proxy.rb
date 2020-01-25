#!/usr/bin/env ruby

require "down"

require "prawn"
require "prawn/measurement_extensions"


list = {
	"Sweet Oblivion": 4,
	"Ashiok, Nightmare Muse": 1,
	"Sphinx Mindbreaker": 4,
	"Ashiok, Sculptor of Fears": 1,
	"Mindwrack Harpy": 4,
	"Scavenging Harpy": 4, 
	"Tyrant's Scorn": 4
}

tempfiles = {}
# download images

list.keys.each do |name|
	tempfiles[name] = Down.download("https://api.scryfall.com/cards/named?exact=#{name}&format=image&version=border_crop")
	puts tempfiles[name].path
end


ratio = 88.mm/63.mm
cardwidth = 60.mm
cardheight = ratio * cardwidth

Prawn::Document.generate("proxy.pdf", :page_size => "A4", :page_layout => :portrait) do
	count = 0
	y_pos = cursor
	x_pos = 0

	list.each do |entry, number|
		number.times do
			print "#{count} #{entry}"
			image tempfiles[entry].path, :width => cardwidth, :at => [x_pos, cursor]
			count = count + 1
			if (count % 3) == 0
				x_pos = 0
				move_down cardheight
				puts
				puts "----"
			else
				x_pos = x_pos + cardwidth
				print " | "
			end

			if (count % 9) == 0
				start_new_page
				print "===="
			end
		end
	end
end

tempfiles.each do |name, tempfile|
	tempfile.close
end