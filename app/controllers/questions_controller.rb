class QuestionsController < ApplicationController
  def index
    question_id = define_first_answered_question
    redirect_to user_question_path(user_id: params[:user_id], id: question_id)
  end

  def show
    @question = Question.find(params[:id])
    @question_number = define_question_number
    if @question.success == true
      redirect_to user_question_path(user_id: params[:user_id], id: define_first_answered_question)
    end
  end

  def validate
    @question = Question.find(params[:id])
    if @question.answer.downcase == params[:validate][:user_answer].downcase
      @question.success = true
      @question.save
    end
    redirect_to user_question_path(user_id: params[:user_id], id: define_first_answered_question)
  end

  def define_question_number
    number_of_questions = Question.where(user_id: params[:user_id]).count()
    remaining_questions = Question.where(user_id: params[:user_id]).where(success: false).count()
    (number_of_questions - remaining_questions) + 1
  end

  def define_first_answered_question
    current_user_id = params[:user_id]
    Question.where(user_id: current_user_id).where(success: false).first.id
  end
end