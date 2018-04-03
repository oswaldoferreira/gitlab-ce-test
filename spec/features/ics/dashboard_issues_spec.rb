require 'spec_helper'

describe "Dashboard Issues Calendar Feed"  do
  describe "GET /issues" do
    let!(:user)     { create(:user, email: 'private1@example.com', public_email: 'public1@example.com') }
    let!(:assignee) { create(:user, email: 'private2@example.com', public_email: 'public2@example.com') }
    let!(:project1) { create(:project) }
    let!(:project2) { create(:project) }

    before do
      project1.add_master(user)
      project2.add_master(user)
    end

    describe "ics feed" do
      it "renders calendar feed via personal access token" do
        personal_access_token = create(:personal_access_token, user: user)

        visit issues_dashboard_path(:ics, private_token: personal_access_token.token)

        expect(response_headers['Content-Type']).to have_content('text/calendar')
        expect(body).to have_text('BEGIN:VCALENDAR')
      end

      it "renders calendar feed via ics token" do
        visit issues_dashboard_path(:ics, ics_token: user.ics_token)

        expect(response_headers['Content-Type']).to have_content('text/calendar')
        expect(body).to have_text('BEGIN:VCALENDAR')
      end

      context "issue with due date" do
        let!(:issue2) do
          create(:issue, author: user, assignees: [assignee], project: project2, title: 'test title',
                         description: 'test desc', due_date: Date.tomorrow)
        end

        it "renders issue fields" do
          visit issues_dashboard_path(:ics, ics_token: user.ics_token)

          expect(body).to have_text('SUMMARY:test title')
          expect(body).to have_text("DTSTART;VALUE=DATE:#{Date.tomorrow.strftime('%Y%m%d')}")
          expect(body).to have_text("URL:#{issue_url(issue2)}")
        end
      end
    end
  end
end
