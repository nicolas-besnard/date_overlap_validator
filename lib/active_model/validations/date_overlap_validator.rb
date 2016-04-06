module ActiveModel
  module Validations
    class DateOverlapValidator < ActiveModel::Validator
      def validate(record)
        starts_at_field = options.fetch(:starts_at_field, :starts_at)
        ends_at_field   = options.fetch(:ends_at_field, :ends_at)

        starts_at = record.public_send(starts_at_field.to_sym)
        ends_at   = record.public_send(ends_at_field.to_sym)

        if starts_at && ends_at
          dates = record.class.where("? < #{ends_at_field} AND ? > #{starts_at_field}", starts_at, ends_at)

          if record.persisted?
            dates = dates.where('id != ?', record.id)
          end

          dates = dates.count

          if dates > 0
            record.errors[starts_at_field] << 'already exists'
          end
        else
          false
        end
      end
    end
  end
end
