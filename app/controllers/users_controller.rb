class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])          # Userを取り出して分割した値を@usersに代入
  end

  def show
    @user = User.find(params[:id])                                              # paramsで:idパラメータを受け取る(/users/1にアクセスしたら1を受け取る)
    redirect_to root_url and return unless @user.activated?                     # activatedがfalseならルートURLヘリダイレクト
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
      if @user.save
        @user.send_activation_email
        flash[:info] = "メールを確認してアカウントを有効化してね."
        redirect_to root_url
      else
        render 'new'
      end
  end

  def edit
    @user = User.find(params[:id])  #before action correct_userで定義しているので削除
  end

  def update
    @user = User.find(params[:id])  #before action correct_userで定義しているので削除
    if @user.update_attributes(user_params)
      flash[:success] = "更新！されました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除されました"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # beforeアクション

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてね"
      redirect_to login_url
    end
  end

  # 正しいユーザーかどうか確認
  def correct_user
  @user = User.find(params[:id])
  redirect_to(root_url) unless current_user?(@user)
  end

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
