defmodule Vutuv.User do
  use Vutuv.Web, :model
  use Arc.Ecto.Schema
  @derive {Phoenix.Param, key: :active_slug}

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :middlename, :string
    field :nickname, :string
    field :honorific_prefix, :string
    field :honorific_suffix, :string
    field :gender, :string
    field :birthdate, Ecto.Date
    field :verified, :boolean, default: false
    field :avatar, Vutuv.Avatar.Type
    field :magic_link, :string
    field :magic_link_created_at, Ecto.DateTime
    field :active_slug, :string
    field :administrator, :boolean
    has_many :groups,         Vutuv.Group,        on_delete: :delete_all
    has_many :emails,         Vutuv.Email,        on_delete: :delete_all
    has_many :user_skills,    Vutuv.UserSkill,    on_delete: :delete_all
    has_many :slugs,          Vutuv.Slug
    has_many :user_urls,      Vutuv.UserUrl,      on_delete: :delete_all
    has_many :user_dates,     Vutuv.UserDate,     on_delete: :delete_all
    has_many :phone_numbers,  Vutuv.PhoneNumber,  on_delete: :delete_all

    has_many :follower_connections, Vutuv.Connection, foreign_key: :followee_id, on_delete: :delete_all
    has_many :followers, through: [:follower_connections, :follower]

    has_many :followee_connections, Vutuv.Connection, foreign_key: :follower_id, on_delete: :delete_all
    has_many :followees, through: [:followee_connections, :followee]

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(first_name last_name middlename nickname honorific_prefix honorific_suffix gender birthdate)

  @required_file_fields ~w()
  @optional_file_fields ~w(avatar)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @optional_fields)
    |> cast_attachments(params, [:avatar])
    |> cast_assoc(:emails)
    |> cast_assoc(:slugs)
    |> validate_first_name_or_last_name_or_nickname(params)
    |> validate_length(:first_name, max: 50)
    |> validate_length(:last_name, max: 50)
    |> validate_length(:middlename, max: 50)
    |> validate_length(:nickname, max: 50)
    |> validate_length(:honorific_prefix, max: 50)
    |> validate_length(:honorific_suffix, max: 50)
    |> validate_length(:gender, max: 50)
    |> downcase_value
  end

  def validate_first_name_or_last_name_or_nickname(changeset, :empty) do
    changeset
  end

  def validate_first_name_or_last_name_or_nickname(changeset, _) do
    first_name = get_field(changeset, :first_name)
    last_name = get_field(changeset, :last_name)
    nickname = get_field(changeset, :nickname)

    if first_name || last_name || nickname do
      # No error if any of those 3 are present.
      #
      changeset
    else
      # All the 3 fields are nil.
      #
      message = "First name or last name or nickname must be present"
      changeset
      |> add_error(:first_name, message)
      |> add_error(:last_name, message)
      |> add_error(:nickname, message)
    end
  end

  def downcase_value(changeset) do
    # If the value has been changed, downcase it.
    update_change(changeset, :active_slug, &String.downcase/1)
  end

  defimpl String.Chars, for: Vutuv.User do
    def to_string(user), do: "#{user.first_name} #{user.last_name}"
  end

  defimpl List.Chars, for: Vutuv.User do
    def to_charlist(user), do: '#{user.first_name} #{user.last_name}'
  end
end
