# Copyright (C) 2012-2016 Zammad Foundation, http://zammad-foundation.org/

class Organization < ApplicationModel
  include HasActivityStreamLog
  include ChecksClientNotification
  include ChecksLatestChangeObserved
  include HasHistory
  include HasSearchIndexBackend
  include CanCsvImport
  include Organization::ChecksAccess

  load 'organization/assets.rb'
  include Organization::Assets
  extend Organization::Search
  load 'organization/search_index.rb'
  include Organization::SearchIndex

  # rubocop:disable Rails/InverseOf
  has_many :members, class_name: 'User'
  # rubocop:enable Rails/InverseOf

  before_create :domain_cleanup
  before_update :domain_cleanup

  validates :name, presence: true

  activity_stream_permission 'admin.role'

  private

  def domain_cleanup
    return true if domain.blank?
    domain.gsub!(/@/, '')
    domain.gsub!(/\s*/, '')
    domain.strip!
    domain.downcase!
    true
  end

end
