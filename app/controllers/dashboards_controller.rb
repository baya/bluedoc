# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :authenticate_anonymous!
  before_action :authenticate_user!

  def index
    @groups = current_user.groups.with_attached_avatar.limit(100)
    @recent_docs = current_user.user_actives.docs.limit(12)
    @recent_repos = current_user.user_actives.repositories.limit(12)
  end

  def activities
    @activities = current_user.activities.includes(:actor, :target).page(params[:page]).per(20)
  end

  def show
    redirect_to root_path
  end

  def groups
    @groups = current_user.groups.with_attached_avatar.page(params[:page]).per(12)
  end

  def repositories
    @repositories = current_user.user_actives.repositories.includes(:user).page(params[:page]).per(12)
  end

  def docs
    @docs = current_user.user_actives.docs.page(params[:page]).per(12)
  end

  # GET /dashboard/stars?tab=
  def stars
    case params[:tab]
    when "docs"
      @docs = current_user.star_docs.includes(repository: :user).page(params[:page]).per(12)
    when "notes"
      @notes = current_user.star_notes.includes(:user).page(params[:page]).per(12)
    else
      @repositories = current_user.star_repositories.includes(:user).page(params[:page]).per(12)
    end
  end

  def watches
    @repositories = current_user.watch_repositories.includes(:user).page(params[:page]).per(12)
  end
end
