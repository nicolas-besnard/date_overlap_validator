require 'spec_helper'

RSpec.describe ActiveModel::Validations::DateOverlapValidator do
  describe "default validation" do
    Event.class_eval do
      validates :starts_at, date_overlap: true
    end

    let(:first_session) { Event.create(starts_at: "2016-04-01 00:00:00 +0200", ends_at: "2016-04-30 00:00:00 +0200") }

    context "a session is in the middle of an other one" do
      it "is invalid" do
        record = Event.new(starts_at: first_session.starts_at + 10.day, ends_at: Time.now + 1.month)
        record.valid?

        puts record.errors.inspect

        expect(record.errors).to have_key(:starts_at)
      end
    end

    context "a session ends after an other starts" do
      it "is invalid" do
        record = Event.new(starts_at: first_session.starts_at - 10.day, ends_at: first_session.starts_at + 1.day)
        record.valid?
        expect(record.errors).to have_key(:starts_at)
      end
    end

    context "a sessions starts before an other ends" do
      it "is invalid" do
        record = Event.new(starts_at: first_session.ends_at - 1.day, ends_at: first_session.ends_at + 1.month)
        record.valid?
        expect(record.errors).to have_key(:starts_at)
      end
    end

    context "a session starts before and finish after an other one" do
      it "is invalid" do
        record = Event.new(starts_at: first_session.starts_at - 1.day, ends_at: first_session.ends_at + 1.day)
        record.valid?
        expect(record.errors).to have_key(:starts_at)
      end
    end
  end

  describe "custom options" do
    CustomFieldEvent.class_eval do
      validates :custom_starts_at, date_overlap: { starts_at_field: :custom_starts_at, ends_at_field: :custom_ends_at }
    end

    let(:first_session) { CustomFieldEvent.create(custom_starts_at: "2016-04-01 00:00:00 +0200", custom_ends_at: "2016-04-30 00:00:00 +0200") }

    context "a session is in the middle of an other one" do
      it "is invalid" do
        record = CustomFieldEvent.new(custom_starts_at: first_session.custom_starts_at + 10.day, custom_ends_at: Time.now + 1.month)
        record.valid?

        puts record.errors.inspect

        expect(record.errors).to have_key(:custom_starts_at)
      end
    end

    context "a session ends after an other starts" do
      it "is invalid" do
        record = CustomFieldEvent.new(custom_starts_at: first_session.custom_starts_at - 10.day, custom_ends_at: first_session.custom_starts_at + 1.day)
        record.valid?
        expect(record.errors).to have_key(:custom_starts_at)
      end
    end

    context "a sessions starts before an other ends" do
      it "is invalid" do
        record = CustomFieldEvent.new(custom_starts_at: first_session.custom_ends_at - 1.day, custom_ends_at: first_session.custom_ends_at + 1.month)
        record.valid?
        expect(record.errors).to have_key(:custom_starts_at)
      end
    end

    context "a session starts before and finish after an other one" do
      it "is invalid" do
        record = CustomFieldEvent.new(custom_starts_at: first_session.custom_starts_at - 1.day, custom_ends_at: first_session.custom_ends_at + 1.day)
        record.valid?
        expect(record.errors).to have_key(:custom_starts_at)
      end
    end
  end
end
