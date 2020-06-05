require 'open-uri'
require 'csv'

namespace :download do
  task :counties, [:name] => [:environment] do |t, args|
    target_county = args[:name] || :all
    url = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv'
    filename = 'us-counties.csv'
    download = open(url)
    IO.copy_stream(download, filename )
    table = CSV.parse(File.read(filename), headers: true)
    counties = {}
    table.each do |row|

      date = row['date']
      county = row['county']
      state = row['state']
      fips = row['fips']
      cases = row['cases'].to_i
      deaths = row['cases'].to_i


      # Find or create the counties
      county = counties["#{county}|#{state}|#{fips}"] ||= County.find_or_create_by!(name: county, state: state, fips: fips)

      # Create or update the cases
      if [county.name, :all].include?(target_county)
        caseload = Caseload.where(date: date, county: county).first || Caseload.new(date: date, county: county)
        caseload.update!(cases: cases, deaths: deaths)
      end
    end
  end
end