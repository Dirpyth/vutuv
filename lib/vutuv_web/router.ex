defmodule VutuvWeb.Router do
  use VutuvWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VutuvWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    #get "/confirm", ConfirmController, :index
    #resources "/password_resets", PasswordResetController, only: [:new, :create]
    #get "/password_resets/edit", PasswordResetController, :edit
    #put "/password_resets/update", PasswordResetController, :update
  end

  # Other scopes may use custom stacks.
  # scope "/api", VutuvWeb do
  #   pipe_through :api
  # end
end
