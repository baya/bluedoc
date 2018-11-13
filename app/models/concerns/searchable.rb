# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    mapping do
      indexes :slug, term_vector: :yes
      indexes :title, term_vector: :yes
      indexes :body, term_vector: :yes
    end

    index_name do
      "#{Rails.env}-#{name.pluralize}".downcase
    end
    document_type name.underscore

    after_commit on: :create do
      self.reindex
    end

    after_update do
      need_update = false
      if self.respond_to?(:indexed_changed?)
        need_update = indexed_changed?
      end

      SearchIndexJob.perform_later("update", self.class.name, self.id) if need_update
    end

    after_commit on: :destroy do
      SearchIndexJob.perform_later("delete", self.class.name, self.id)
    end
  end

  def reindex
    SearchIndexJob.perform_later("index", self.class.name, self.id)
  end
end