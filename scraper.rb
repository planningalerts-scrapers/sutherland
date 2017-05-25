require 'scraperwiki'
require 'mechanize'

url = "https://feeds.ssc.nsw.gov.au/?page=PlanningAlerts"
comment_url = "mailto:ssc@ssc.nsw.gov.au"

agent = Mechanize.new
agent.verify_mode = OpenSSL::SSL::VERIFY_NONE

page = Nokogiri::XML(agent.get(url).body)

page.search("application").each do |app|

  record = {
    "council_reference" => app.at("council_reference").inner_text,
    "address" => app.at("address").inner_text,
    "description" => app.at("description").inner_text,
    "info_url" => app.at("info_url").inner_text,
    "comment_url" => comment_url,
    "date_scraped" => Date.today.to_s
  }

  # Optional fields
  if app.at("date_received") && app.at("date_received").inner_text != ""
    record["date_received"] = app.at("date_received").inner_text
  end
  if app.at("on_notice_from") && app.at("on_notice_from").inner_text != ""
    record["on_notice_from"] = app.at("on_notice_from").inner_text
  end
  if app.at("on_notice_to") && app.at("on_notice_to").inner_text != ""
    record["on_notice_to"] = app.at("on_notice_to").inner_text
  end

  if (ScraperWiki.select("* from data where `council_reference`='#{record['council_reference']}'").empty? rescue true)
    puts "Saving record " + record['council_reference'] + " - " + record['address']
#     puts record
    ScraperWiki.save_sqlite(['council_reference'], record)
  else
    puts "Skipping already saved record " + record['council_reference']
  end
end
