Feature: Register attendance of confirmed users

	In order to recognize merit
	As the proponent of a session
	I want to register people that attended it

	Scenario: 

		Given I am logged in as "bruno"
		And there is a session with title "my session" scheduled for today
		And there are 3 people confirmed in a session
		And I am on the session detail page
		When I check attendance_checkbox on user 1
		And I check attendance_checkbox on user 2
		And I click register_attendance button
		Then I should be on the session detail page
		And I should see a successful message
		And I should see attendees' names in bold font
		And I should see attendees' checkboxes checked


	Scenario: only proponent can register attendance
	Scenario: attendance can be registered only for past sessions
