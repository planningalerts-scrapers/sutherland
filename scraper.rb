require File.join(File.dirname(__FILE__), "planningalerts_xml_feed", "planningalerts_xml_feed")

PlanningAlertsXMLFeed.scrape("https://feeds.ssc.nsw.gov.au/?page=PlanningAlerts")
