FactoryBot.define do
  factory :post do
    title { FFaker::Company.position }
    content { FFaker::HTMLIpsum.body }
  end
end