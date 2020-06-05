class CountiesController < ApplicationController
  def index
    @counties = County.all
  end

  def show
    @county = County.find(params[:id])

    if @county.name == 'New York City' # Hack -- only NYC to save $$$
      FetchCases.call(county: @county)
    end
    @cases_by_date = @county.caseloads.order('date ASC').pluck(:date, :cases)

    @new_cases_by_date = (0...@cases_by_date.size).map do |index|
      new_cases(@cases_by_date, index)
    end
  end

  private

  def new_cases(dates_and_cases, index)
    date_case = dates_and_cases[index].dup

    if index == 0
      date_case
    else
      date_case[1] = cases_delta(dates_and_cases, index) # TODO: fix primitive obsession
      date_case
    end
  end

  def cases_delta(dates_and_cases, index)
    dates_and_cases[index][1] - dates_and_cases[index - 1][1]
  end
end
