json.array!(@tops) do |top|
  json.extract! top, :id
  json.url top_url(top, format: :json)
end
