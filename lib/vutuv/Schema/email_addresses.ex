defmodule Vutuv.EmailAddress do
  use Ecto.Schema
  import Ecto.Changeset

  schema "email_addresses" do
    belongs_to :user, Vutuv.User
    field :value, :string
    field :description, :string
    field :is_public, :boolean, default: true
    field :position, :integer

    timestamps()
  end

  #@required_fields ~w(value public? user_id)

  @doc false
  def changeset(email_address, attrs) do
    email_address
    |> cast(attrs, [:user, :value, :description, :is_public, :position])
    |> validate_required([:value, :public?, :user])
    |> downcase_value
    |> validate_format(:value, ~r/@/)
    |> unique_constraint(:value, downcase: true)
  end

  def downcase_value(changeset) do
    # If the value has been changed, downcase it.
    update_change(changeset, :value, &String.downcase/1)
  end

end
