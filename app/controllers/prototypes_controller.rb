class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_prototype, only: [:edit, :show]

  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.create(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      @prototypes = Prototype.includes(:user)
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  def edit
    unless current_user.id == @prototype.user.id
      redirect_to action: :index
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to @prototype
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end


  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

end
