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
    user = User.find(params[:user_id])
    if @question.answer.downcase == params[:validate][:user_answer].downcase
      @question.success = true
      @question.save
      user.score = Question.all.where(user_id: params[:user_id]).where(success: true).count
      user.score = "max" if define_number_of_questions.to_s == user.score
      user.save
      puts "---"
      puts "user.score"
      puts "---"
    end
    if user.score != "max"
      redirect_to user_question_path(user_id: params[:user_id], id: define_first_answered_question)
    else
      redirect_to root_path
    end
  end


  def define_number_of_questions
    Question.all.where(user_id: params[:user_id]).count()
  end

  def define_question_number 
    remaining_questions = Question.where(user_id: params[:user_id]).where(success: false).count()
    (define_number_of_questions  - remaining_questions) + 1
  end

  def define_first_answered_question
    current_user_id = params[:user_id]
    Question.where(user_id: current_user_id).where(success: false).first.id
  end
end