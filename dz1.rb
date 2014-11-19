require 'selenium-webdriver'

browser = Selenium::WebDriver.for :firefox
browser.get 'http://demo.redmine.org'

#Account creation
attempt = '5573'
login = 'test_login' + attempt
email = login + '@mail.test'

browser.find_element(:link => 'Register').click

sleep 2

browser.find_element(:id => 'user_login').send_keys login
browser.find_element(:id => 'user_password').send_keys 'qwerty'
browser.find_element(:id => 'user_password_confirmation').send_keys 'qwerty'
browser.find_element(:id => 'user_firstname').send_keys 'first_name'
browser.find_element(:id => 'user_lastname').send_keys 'last_name'
browser.find_element(:id => 'user_mail').send_keys (email)

sleep 2

browser.find_element(:name => 'commit').click

sleep 2

#Checking that Account is created
fail 'Couldn\'t find success message' if browser.find_element(:id => 'flash_notice').text != 'Your account has been activated. You can now log in.'
fail 'We are not logged in' unless browser.find_element(:css => '#loggedas .user').text == login
fail 'Email is not "user@mail.test"' unless browser.find_element(:xpath => ".//*[@id='user_mail']").attribute('value') == email
if browser.find_element(:xpath => ".//*[@id='user_firstname']").attribute('value') != 'first_name'
	fail 'First name is not "first name"'
end
fail 'Last name is not "last name"' unless browser.find_element(:xpath => ".//*[@id='user_lastname']").attribute('value') == 'last_name'

sleep 2

#Project creation
ident = 'id' + attempt

browser.find_element(:link => 'Home').click
browser.find_element(:link => 'create your own project').click

browser.find_element(:id => 'project_name').send_keys ('project' + ident)
browser.find_element(:id => 'project_description').send_keys 'my test description'
browser.find_element(:id => 'project_identifier').clear
browser.find_element(:id => 'project_identifier').send_keys ident
sleep 2
browser.find_element(:name => 'commit').click

#Checking that Project is created
fail 'Couldn\'t find Successful creation message' unless browser.find_element(:id => 'flash_notice').text == 'Successful creation.'
fail 'Project URL is incorrect' unless browser.current_url == ('http://demo.redmine.org/projects/' + ident + '/settings')


#Issue creation
browser.get ('http://demo.redmine.org/projects/' + ident)
browser.find_element(:xpath => ".//*[@id='main-menu']/ul/li[4]/a").click
browser.find_element(:xpath => ".//*[@id='issue_subject']").send_keys 'first issue'
browser.find_element(:xpath => ".//*[@id='issue_description']").send_keys 'first issue description'
#browser.find_element(:xpath => ".//*[@id='issue_assigned_to_id']").select_by(:text, "<< me >>")
sleep 2
browser.find_element(:xpath => " .//*[@id='issue-form']/input[1]").click

#Checking that Issue is created
fail 'Seems that issue is not created' unless browser.find_element(:xpath => ".//*[@id='flash_notice']/a").attribute('title') == 'first issue'
fail 'Seems that this issue is not yours' unless browser.find_element(:xpath => ".//*[@id='content']/div[3]/p/a[1]").text == 'first_name last_name'




#browser.find_element(:id => 'user_firstname').send_keys 'first_name'
#browser.find_element(:id => 'user_lastname').send_keys 'last_name'
#browser.find_element(:id => 'user_mail').send_keys (email)

#browser.find_element(:id => 'user_firstname').clear
#browser.find_element(:id => 'user_firstname').send_keys 'new first name'
#browser.find_element(:name => 'commit').click

#fail 'Couldn\'t find success message' unless browser.find_element(:id => 'flash_notice').text == 'Account was successfully updated.'

browser.close
