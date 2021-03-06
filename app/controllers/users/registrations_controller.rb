# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # prepend_before_action :check_recaptcha, only: [:create]
  before_action :authenticate_scope!, only: [:confirm_phone, :new_address, :create_address] 
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  layout 'no_menu'

  # GET /resource/sign_up
def new
  @progress = 1  ## 追加
  if session["devise.sns_auth"]
    ## session["devise.sns_auth"]がある＝sns認証
    build_resource(session["devise.sns_auth"]["user"])
    @sns_auth = true
  else
    ## session["devise.sns_auth"]がない=sns認証ではない
    super
  end
end


  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  def select
    session.delete("devise.sns_auth")
    @auth_text = "で登録する"
  end

  def confirm_phone
    @progress = 2
  end

  def new_address
    @progress = 3
    @address = Address.new
  end

  def create_address
    @progress = 5
    @address = Address.new(address_params)
    unless @address.save!
      redirect_to users_new_address_path, alert: @address.errors.full_messages
    end
  end
 
  private
  def after_sign_up_path_for(resource)
    users_confirm_phone_path
  end

  def address_params
    params.require(:address).permit(
      :phone_number,
      :postal_code,
      :prefecture_id,
      :city,
      :house_number,
      :building_name,
      ).merge(user_id: current_user.id)
  end
  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end

