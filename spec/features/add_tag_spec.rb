feature 'tagging links' do
  scenario 'Can add tags to a new link' do
    visit '/links/add'
    fill_in(:url, with: 'google.com')
    fill_in(:title, with: 'live')
    fill_in(:tags, with: 'search')
    click_button('Add link')
    link = Link.first
    expect(link.tags.map(&:tags)).to include('search')
    end

   scenario 'filter links by tag' do
     visit '/links/add'
     fill_in(:url, with: 'bubbles.com')
     fill_in(:title, with: 'Pretty bubbles in the air')
     fill_in(:tags, with: 'bubbles')
     click_button('Add link')
     visit './tags/bubbles'
     expect(page).to have_content 'bubbles'
   end

   scenario 'adds multiple tags to links' do
     visit '/links/add'
     fill_in(:url, with: 'bubbles.com')
     fill_in(:title, with: 'Pretty bubbles in the air')
     fill_in(:tags, with: 'bubbles air')
     click_button('Add link')
     link = Link.first
     expect(link.tags.map(&:tags)).to include('bubbles', 'air')
   end
end
