# encoding: utf-8
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "helper"))

Given /^there are no proposed sessions$/ do
  DojoSession.find_proposed_sessions.should be_empty
end


Given /^the following sessions exist:$/ do |table|
  table.hashes.each do |hash|	
		hash[:date] = calculate_relative_date(hash[:date]) if hash[:date]
		d = Factory.create :dojo_session, hash
		
		#FIXME I dont know why the factory is not assigning the date :-/
		d.date=hash[:date] if hash[:date]
		d.save
		
	end
end

Given /^I reach the detail page of session "([^"]*)"$/ do |title|
  id = DojoSession.find_by_title(title).id
  visit "/dojo_sessions/#{id}"
end


Given /^there is a session scheduled for (.*)$/ do |date|
	Given %{there is a session with title "any one" scheduled for #{date}}
end



Given /^there is a session with title "(.*)" scheduled for (.*)$/ do |title, date|
	real_date = calculate_relative_date(date)
	Factory.create :dojo_session, :title=> title, :date=>real_date  
end

Given /^I am confirmed in the session "([^\"]*)"$/ do |title|
  visit path_to('lista de sessões')
	id = DojoSession.find_by_title(title).id
	within "#dojo_session_#{id}" do
	  click_link "Confirm my presence"
  end
end

Given /^there are (\d+) people confirmed in the session "([^\"]*)"$/ do |how_many, title|
  s = DojoSession.find_by_title(title)
  how_many.to_i.times do 
  	s.confirmed_users << Factory.create(:user)
  end
  s.save
end




When /^I fill the proposal with "([^\"]*)", "([^\"]*)", "([^\"]*)", "([^\"]*)", and "([^\"]*)"$/ do |title, text, place, date, time|
	fill_in "dojo_session[title]", :with => title
	fill_in "dojo_session[text]", :with => text
	fill_in "dojo_session[place]", :with => place
	
	date = calculate_relative_date(date)
	
	fill_in "dojo_session[date]", :with => date.to_s
	fill_in "dojo_session[time]", :with => time
end

When /^I check attendance_checkbox on user (\d+)$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

When /^I click register_attendance button$/ do
  pending # express the regexp above with the code you wish you had
end



Then /^I should see the following session details:$/ do |table|
	table.hashes.each do |hash|
		within("div") do |div|
	  	page.should have_content(hash[:title])
			date_time_place = /.*#{I18n.l(calculate_relative_date(hash[:date]), :format=>:pretty)}.*#{hash[:time]}.*#{hash[:place]}.*/
			within("span") do |span|
			  #page.should have_content(date_time_place)
			  
			  page.should have_xpath('//*', :text => date_time_place)
				#assert_contains date_time_place
			end
			# div.should have_tag("span", date_time_place)
		end
	end
end




Then /^I should see "([^\"]*)" in the confirmed users list$/ do |username|
	within("div#confirmations") do |div|
		page.should have_content "Confirmed"
		page.should have_content username
	end
end

Then /^I should not see "([^\"]*)" in the confirmed users list$/ do |username|
	doc = Nokogiri::HTML(page.body)
	dojo = doc.search('div.box #confirmations')
	dojo.should_not have_content(username)
	dojo.should have_content('Confirm my presence')
end


#TODO: transform into array
Then /^I should see the titles (.*), (.*), (.*), (.*), (.*)$/ do |t1,t2,t3,t4,t5|
  page.should have_content t1
  page.should have_content t2
  page.should have_content t3
  page.should have_content t4
  page.should have_content t5
end

Then /^I should see the sessions details in this specific order (.*), (.*), (.*)$/ do |a,b,c|
  doc = Nokogiri::HTML(page.body)
	dojo = doc.search('h2')
	dojo[0].content.should == a
	dojo[1].content.should == b
	dojo[2].content.should == c
end

Then /^I should see a successful message$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see attendees' names in bold font$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see attendees' checkboxes checked$/ do
  pending # express the regexp above with the code you wish you had
end

