# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups = current_user.groups.with_attached_avatar.limit(10)
    @recent_docs = current_user.user_actives.docs.limit(5)
    @activities = current_user.activities.includes(:actor, :target).offset(params[:offset]).limit(20)
  end

  def show
    redirect_to root_path
  end

  def groups
    @groups = current_user.groups.with_attached_avatar.page(params[:page]).per(10)
  end

  def repositories
    @repositories = current_user.repositories.includes(:user).page(params[:page]).per(10)
  end

  def docs
    @user_actives = current_user.user_actives.docs.page(params[:page]).per(10)
  end

  def stars
    @repositories = current_user.star_repositories.includes(:user).page(params[:page]).per(10)
  end

  def watches
    @repositories = current_user.watch_repositories.includes(:user).page(params[:page]).per(10)
  end
end
