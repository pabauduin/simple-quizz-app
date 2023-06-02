class UsersController < ApplicationController
  def index
    if params[:user].present? && params[:user][:username].present?
      username = params[:user][:username]
      user = User.find_by(username: username)
      if user
        redirect_to user_questions_path(user)
      else
        flash[:notice] = "User not found."
        create
      end
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      create_questions
      redirect_to user_question_path(user_id: @user.id, id: define_first_answered_question)
      flash[:success] = "User created successfully!"
    elsif !@user.nil?
      redirect_to user_question_path(user_id: @user.id, id: define_first_answered_question)
    else
      render :new
    end
  end

  def new
    @user = User.new
  end

  def create_questions
    json_file_path = Rails.root.join('app', 'data', 'questions.json')
    json_data = JSON.parse(File.read(json_file_path))

    puts json_data.entries

    json_data.entries.each do |question, answer|
      @question = Question.new(user_id: @user.id, question: question, "answer": answer, "success": "false")
      @question.save
    end
  end

  def define_first_answered_question
    Question.where(user_id: @user.id).where(success: false).first.id
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end
end
