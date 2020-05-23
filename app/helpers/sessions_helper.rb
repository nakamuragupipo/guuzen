module SessionsHelper

    # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

   # 現在ログイン中のユーザーを返す (いる場合)
   def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end

  # ユーザーをログアウトする

  def log_out
    session.delete(:user_id)                                                    # セッションのuser_idを削除する
    @current_user = nil                                                         # 現在のログインユーザー（一時的なcookies）をnil（空に）する
  end

end
