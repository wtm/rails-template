SCRIPT_PATH = File.expand_path(File.dirname(__FILE__))

# delete unnecessary files
run "rm README public/index.html public/favicon.ico public/robots.txt"

# gems
gem 'bluecloth'               # markdown implemented in c
gem 'carrierwave'							# file attachment
gem 'clearance'               # authentication
gem 'haml'                    # crazy html
gem 'pg'                      # postgresql
gem 'formtastic'              # simplified dsl for semantic forms
gem 'kaminari'                # pagination
gem 'cancan'                  # access control

# testing gems
gem 'rspec-rails', group: [ :test, :development ]
gem 'capybara', group: [ :test, :development ]
gem 'factory_girl_rails', group: [ :test, :development ]


# create user
if yes?("Multi-tenant application?")
	generate "model User email name role organization_id:integer" # basic user
	generate "model Organization name"														# for multi-tenant auth
	generate "clearance:install"																	# authentication specifics
else
	generate "model User email name role" # basic user
	generate "clearance:install"					# authentication specifics
end

# install gems!
run "bundle"
generate "rspec:install"      # rspec
generate "clearance:views"    # user views
generate "formtastic:install" # formtastic css
generate "cancan:ability"     # ability class

# iterate over files in folder and copy them
# into the rails application manually
Dir.glob("#{SCRIPT_PATH}/**/*.*") do |filename|
  next if filename == "base.rb"
  file filename.gsub("#{SCRIPT_PATH}/", ""), File.read(filename)
end

# setup git
git :init
git add: "."
git commit: "-m Initial commit"
git remote: "add origin #{ask('URL of Github repo?')}"
