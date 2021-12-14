require 'rails_helper'
require_relative './web_helper.rb'

RSpec.feature 'Post Image', type: :feature do
  scenario 'There is a New Post Image button' do
    sign_up
    log_in
    expect(page).to have_content('New Post Image')
  end

  scenario 'can create a new image' do
    sign_up
    log_in
    click_link 'New Post Image'
    expect(page).to have_content('New Post Image')
    fill_in 'post_image[title]', with: 'Hello Cat'
    fill_in 'post_image[content]', with: 'This is a photo of an evil cat'

    # we do not know how to check for an image file
    # fill_in 'post_image[image]', with: 'thisisadummystingforimg'
    click_button 'Create Post image'
    expect(page).to have_content('Post was successfully created.')
  end

  scenario 'There is a New Post Image link' do
    sign_up
    log_in
    click_link 'New Post Image'
    expect(page).to have_content('New Post Image')
  end

  scenario 'can create a comment' do
    sign_up
    log_in
    click_link 'New Post Image'
    fill_in 'post_image[title]', with: 'Hello Cat'
    fill_in 'post_image[content]', with: 'This is a photo of an evil cat'
    click_button 'Create Post image'
    fill_in 'comment[commenter]', with: 'Test comment'
    fill_in 'comment[body]', with: 'this is the first comment'
    click_button 'Create Comment'
    expect(page).to have_content('Commenter: Test comment')
    expect(page).to have_content('Comment: this is the first comment')
  end

  scenario 'can delete a comment' do
    sign_up
    log_in
    click_link 'New Post Image'
    fill_in 'post_image[title]', with: 'Hello Cat'
    fill_in 'post_image[content]', with: 'This is a photo of an evil cat'
    click_button 'Create Post image'
    fill_in 'comment[commenter]', with: 'Test comment'
    fill_in 'comment[body]', with: 'this is the first comment'
    click_button 'Create Comment'
    click_link 'Destroy Comment'
    expect(page).not_to have_content('Commenter: Test comment')
    expect(page).not_to have_content('Comment: this is the first comment')
  end

  scenario 'shows the number of comments on a photo' do
    sign_up
    log_in
    click_link 'New Post Image'
    fill_in 'post_image[title]', with: 'Hello Cat'
    fill_in 'post_image[content]', with: 'This is a photo of an evil cat'
    click_button 'Create Post image'
    fill_in 'comment[commenter]', with: 'Test comment'
    fill_in 'comment[body]', with: 'this is the first comment'
    click_button 'Create Comment'
    fill_in 'comment[commenter]', with: 'Test comment'
    fill_in 'comment[body]', with: 'this is the first comment'
    click_button 'Create Comment'
    click_link 'Back'
    expect(page).to have_content('Number of comments: 2')
  end

  scenario 'defaults to zero comments' do
    sign_up
    log_in
    click_link 'New Post Image'
    fill_in 'post_image[title]', with: 'Hello Cat'
    fill_in 'post_image[content]', with: 'This is a photo of an evil cat'
    click_button 'Create Post image'
    click_link 'Back'
    expect(page).to have_content('Number of comments: 0')
  end

  scenario 'you can see when an Image was created' do
    time = Time.now.strftime('%A %d %B %Y, %I:%M%p')
    sign_up
    log_in
    click_link 'New Post Image'
    fill_in 'post_image[title]', with: 'Hello Cat'
    fill_in 'post_image[content]', with: 'This is a photo of an evil cat'
    click_button 'Create Post image'
    click_link 'Back'
    expect(page).to have_content("Timestamp: #{time}")
  end

  scenario 'you can see when a comment was made' do
    time = Time.now.strftime('%A %d %B %Y, %I:%M%p')
    sign_up
    log_in
    click_link 'New Post Image'
    fill_in 'post_image[title]', with: 'Hello Cat'
    fill_in 'post_image[content]', with: 'This is a photo of an evil cat'
    click_button 'Create Post image'
    fill_in 'comment[commenter]', with: 'Test comment'
    fill_in 'comment[body]', with: 'this is the first comment'
    click_button 'Create Comment'
    expect(page).to have_content("Timestamp: #{time}")
  end

  scenario 'checks the order of images/posts are reverse chronological' do
    sign_up
    log_in
    click_link 'New Post Image'
    fill_in 'post_image[title]', with: 'Hello Cat'
    fill_in 'post_image[content]', with: 'This is a photo of an evil cat'
    click_button 'Create Post image'
    click_link 'Back'
    click_link 'New Post Image'
    fill_in 'post_image[title]', with: 'This is the Second Post'
    fill_in 'post_image[content]', with: 'This is a photo of an evil cat again'
    click_button 'Create Post image'
    click_link 'Back'
    expect(page.find('div.container:last')).to have_content 'Hello Cat'
  end

  scenario 'User can like post' do
    sign_up
    log_in
    click_link 'New Post Image'
    fill_in 'post_image[title]', with: 'Hello Cat'
    fill_in 'post_image[content]', with: 'This is a photo of an evil cat'
    click_button 'Create Post image'
    click_link 'Back'
    first(:button, 'Like').click
    expect(page).to have_content('1Like')
  end

  scenario 'User can unlike post' do
    sign_up
    log_in
    click_link 'New Post Image'
    fill_in 'post_image[title]', with: 'Hello Cat'
    fill_in 'post_image[content]', with: 'This is a photo of an evil cat'
    click_button 'Create Post image'
    click_link 'Back'
    first(:button, 'Like').click
    expect(page).to have_content('1Like')
    first(:button, 'Unlike').click
    expect(page).to have_content('0Likes')
  end

  scenario 'new posts show user details(profile image and email)' do
    sign_up
    log_in
    click_link 'New Post Image'
    fill_in 'post_image[title]', with: 'Hello Cat'
    fill_in 'post_image[content]', with: 'This is a photo of an evil cat'
    click_button 'Create Post image'
    click_link 'Back'
    expect(page).to have_content('user@email.com')
  end
end
