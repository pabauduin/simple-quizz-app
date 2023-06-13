class QuestionsController < ApplicationController
  def index
    @categories = Question.all.pluck(:category).uniq
  end

  def show
    @question = Question.find(params[:id])
    if @question.success == true
      redirect_to user_question_path(user_id: params[:user_id], id: define_first_unanswered_question)
    end
  end

  def validate
    @question = Question.find(params[:id])
    user = User.find(params[:user_id])
    if @question.answer.downcase == params[:validate][:user_answer].downcase
      @question.success = true
      @question.save
      user.score = Question.all.where(user_id: params[:user_id]).where(success: true).count
      user.score = "max" if define_number_of_questions.to_s == user.score
      user.save
      redirect_to user_questions_path(user_id: params[:user_id])
      puts "---"
      puts "user.score"
      puts "---"
    end
  end

  def define_number_of_questions
    Question.all.where(user_id: params[:user_id]).count()
  end

  def define_first_unanswered_question
    current_user_id = params[:user_id]
    Question.where(user_id: current_user_id).where(success: false).first.id
  end
end