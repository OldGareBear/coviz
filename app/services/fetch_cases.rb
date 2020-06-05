require 'open-uri'
require 'csv'

class FetchCases
  DATA_URL = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv'

  def self.call(county:)
    return if county.caseloads.order('date DESC').limit(1).first.date >= Time.zone.today

    filename = 'us-counties.csv'
    download = open(DATA_URL)
    IO.copy_stream(download, filename)
    table = CSV.parse(File.read(filename), headers: true)
    table.each do |row|

      county_name = row['county']

      if county_name == county.name
        date = row['date']
        cases = row['cases'].to_i
        deaths = row['cases'].to_i

        # Create or update the cases
        caseload = Caseload.where(date: date, county: county).first || Caseload.new(date: date, county: county)
        caseload.update!(cases: cases, deaths: deaths)
      end
    end
  end
end