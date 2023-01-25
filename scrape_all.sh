#!/bin/bash
ruby abuseipdb_scrape.rb
ruby firehol_abusers_scrape.rb
ruby firehol_anonymous_scrape.rb
ruby firehol_level2_scrape.rb
ruby firehol_level3_scrape.rb
ruby firehol_webserver_scrape.rb