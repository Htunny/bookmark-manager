def sign_up(email: 'andy_htun@hotmail.com', password: 'Apples', password_confirmation: 'Apples')
  visit('/users/new')
  expect(page.status_code).to eq(200)
  fill_in :email, with: email
  fill_in :password, with: password
  fill_in :password_confirmation, with: password_confirmation
  click_button 'Sign up'
end

def sign_in(email: 'andy_htun@hotmail.com', password: 'Apples')
  User.create(email: email, password: password, password_confirmation: password)
  visit '/session/new'
  expect(page.status_code).to eq(200)
  fill_in :email, with: email
  fill_in :password, with: password
  click_button 'Sign in'
end

def sign_out
  visit '/session/end'
  expect(page.status_code).to eq(200)
  click_button 'Sign out'
end
