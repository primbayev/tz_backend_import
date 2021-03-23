require 'csv'

task import_products: :environment do
  price_list_one = CSV.read('./lib/tasks/csv_files/price_1.csv', headers: true)
  price_list_one.each do |row|
    price_list = 'price_1'
    name = row['Наименование']
    brand = row['Производитель'].downcase
    code = row['Артикул'].downcase
    stock = row['Количество']
    cost = row['Цена'].gsub('>', '')

    create_or_update(price_list, name, brand, code, stock, cost)
  end

  price_list_two = CSV.read(
    './lib/tasks/csv_files/price_2.csv',
    col_sep: ';',
    headers: true,
    liberal_parsing: true
  )

  price_list_two.each do |row|
    price_list = 'price_2'
    name = row['Наименование']
    brand = row['Бренд'].downcase
    code = row["﻿\"Артикул\""].downcase
    stock = row['Количество']
    cost = row['Цена'].gsub('>', '')

    create_or_update(price_list, name, brand, code, stock, cost)
  end

  price_list_three = CSV.read(
    './lib/tasks/csv_files/price_3.csv',
    col_sep: ';',
    headers: true,
    liberal_parsing: true,
    encoding: 'windows-1251'
  )

  price_list_three.each do |row|
    price_list = 'price_3'
    name = row['Наименование']
    brand = row['Производитель'].downcase
    code = row['Номер'].downcase
    stock = row['Кол-во']
    cost = row['Цена'].gsub('>', '')

    create_or_update(price_list, name, brand, code, stock, cost)
  end
end

def create_or_update(price_list, name, brand, code, stock, cost)
  product = Product.find_by(price_list: price_list, code: code, brand: brand)
  if product
    puts "Price list: #{price_list} product with code: #{code} and brand #{brand} was updated"
    product.update(name: name, stock: stock, cost: cost)
  else
    puts "Price list: #{price_list} product with code: #{code} and brand #{brand} was created"

    Product.create(
      price_list: price_list,
      code: code,
      brand: brand,
      name: name,
      stock: stock,
      cost: cost
    )
  end
end
