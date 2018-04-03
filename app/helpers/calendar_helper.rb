require 'icalendar'

module CalendarHelper
  def calendar_url_options
    { format: :ics, ics_token: current_user.try(:ics_token), due_date: Issue::DueInSixWeeksPeriod.name }
  end

  def calendar
    cal = Icalendar::Calendar.new
    cal.prodid = 'GitLab'

    yield cal if block_given?

    cal.to_ical.html_safe
  end

  def add_issue_to_calendar(calendar, issue)
    return unless issue.due_date.present?

    calendar.event do |event|
      event.dtstart     = Icalendar::Values::Date.new(issue.due_date)
      event.summary     = issue.title
      event.url         = issue_url(issue)
    end
  end
end
