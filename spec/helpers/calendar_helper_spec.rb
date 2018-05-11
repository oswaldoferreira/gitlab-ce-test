require 'spec_helper'

describe CalendarHelper do
  describe '#calendar_url_options' do
    context 'when signed in' do
      it "includes the current_user's ics_token" do
        current_user = create(:user)
        allow(helper).to receive(:current_user).and_return(current_user)
        expect(helper.calendar_url_options).to include ics_token: current_user.ics_token
      end
    end

    context 'when signed out' do
      it "does not have an ics_token" do
        allow(helper).to receive(:current_user).and_return(nil)
        expect(helper.rss_url_options[:ics_token]).to be_nil
      end
    end
  end

  describe '#calendar' do
    it "generates calendar feed" do
      expect(helper.calendar).to include 'BEGIN:VCALENDAR'
    end
  end

  describe '#add_issue_to_calendar' do
    subject do
      helper.calendar do |cal|
        helper.add_issue_to_calendar(cal, issue)
      end
    end

    let(:issue) { create(:issue, title: 'test title', due_date: Date.yesterday) }

    it "adds an issue with due date to the calendar feed" do
      expect(subject).to include 'SUMMARY:test title'
    end
  end
end
