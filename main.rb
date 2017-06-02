#MVC, M-Database
require 'sinatra'
require_relative 'Student'
require_relative 'Comment'
require 'erb'
#require 'sinatra/reloader'

configure do
  enable :sessions
  set :session_secrect, "i love you"
  set :username, "admin"
  set :password, "admin"
end

get '/styles.css' do
  scss :styles
end

get '/' do
  @title = "SIS | Home"
  erb :home
end

get '/about' do
  @title = "SIS | About"
  erb :about
end

get '/contact' do
  @title = "SIS | Contact"
  erb :contact
end

get '/students' do
  @title = "SIS | Students"
  @students = Student.all()
  erb :students
end

get '/students/new' do
  if !session[:username]
    redirect '/login'
  else
    @title = "SIS | New a Student"
    @form_title = "Create a New Student"
    @form_action = "/students"
    @form_method = "post"
    @button_value = "Create"
    erb :student_form
  end
end

# new a student
post '/students' do
  student = Student.new()
  student.firstname = params[:fname]
  student.lastname = params[:lname]
  student.student_id = params[:stid]
  student.birthday = params[:bir]
  student.address = params[:addr]
  student.save
  redirect '/students'
end

get '/students/:id' do
  @title = "SIS | Student Information"
  @form_title = "Student Information"
  @form_method = "get"
  @form_action = "/students"
  @existed_student = Student.get(params[:id])
  @button_value = "Go Back"
  erb :student_form
end

get '/students/edit/:id' do
  if !session[:username]
    redirect '/login'
  else
    @title = "SIS | Edit Student Information"
    @form_title = "Edit Student Information"
    @form_action = "/students/" + params[:id]
    @form_method = "post"
    @existed_student = Student.get(params[:id])
    @button_value = "Update"
    erb :student_form
  end
end

# update student information
post '/students/:id' do
  student = Student.get(params[:id])
  student.firstname = params[:fname]
  student.lastname = params[:lname]
  student.student_id = params[:stid]
  student.birthday = params[:bir]
  student.address = params[:addr]
  student.save
  redirect '/students'
end

# delete a student
get '/students/delete/:id' do
  if !session[:username]
    redirect '/login'
  else
    Student.get(params[:id]).destroy
    redirect '/students'
  end
end

get '/comment' do
  @title = "SIS | Comment"
  @comments = Comment.all()
  erb :comment
end

get '/comment/new' do
  @title = "SIS | New a Comment"
  @form_title = "Create a New Comment"
  @form_action = "/comment"
  @form_method = "post"
  @button_value = "Create"
  erb :comment_form
end

# new a comment
post '/comment' do
  comment = Comment.new()
  comment.title = params[:title]
  comment.name = params[:name]
  comment.content = params[:content]
  comment.created_at = Time.now
  comment.save
  redirect '/comment'
end

# read the detail of a comment
get '/comment/:id' do
  @title = "SIS | Comment Information"
  @form_title = "Student Information"
  @form_method = "get"
  @form_action = "/comment"
  @existed_comment = Comment.get(params[:id])
  @button_value = "Go Back"
  erb :comment_form
end

get '/video' do
  @title = "SIS | Video"
  erb :video
end

get '/login' do
  @title = "SIS | Login"
  @form_method = "post"
  @form_action = "/login"
  # display authorized results
  if session[:authmsg]
    @auth_msg = session[:authmsg]
    # the authorization message only needed to be displayed once
    session.delete(:authmsg)
  end
  erb :login_form
end

post '/login' do
  if ((settings.username != params[:uname]) || (settings.password != params[:psw]))
    @title = "SIS | Login"
    @form_method = "post"
    @form_action = "/login"
    session[:authmsg] = "Username or password error, please try again..."
    redirect '/login'
  else
    session[:username] = params[:uname]
    redirect '/'
  end
end

get '/logout' do
  session.clear
  redirect '/login'
end

not_found do
  @title = "SIS | Not Found"
  erb :notfound, :layout => false
end
