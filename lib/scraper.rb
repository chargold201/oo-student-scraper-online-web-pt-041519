require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    scraped_students = []
    students = page.css('div.student-card')

    students.each_with_index do |student, i|
      scraped_students[i] = {
        name: student.css('a div.card-text-container h4').text,
        location: student.css('a div.card-text-container p').text,
        profile_url: student.css('a').attribute('href').value
      }
    end
    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    page = Nokogiri::HTML(open(profile_url))
    student_info = {}

    socials = page.css('div.social-icon-container a')
    socials.each do |social|
      url = social.attribute('href').value
      if url.include?("twitter")
        student_info[:twitter] = url
      elsif url.include?("linkedin")
        student_info[:linkedin] = url
      elsif url.include?("github")
        student_info[:github] = url
      else
        student_info[:blog] = url
      end
    end
    
    student_info[:profile_quote] = page.css('div.profile-quote').text
    student_info[:bio] = page.css('div.bio-block div.bio-content div.description-holder p').text
    
    student_info
  end

end

