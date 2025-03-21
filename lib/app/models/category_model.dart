class CategoryModel {
  CategoryModel({
      this.id, 
      this.name, 
      this.subCategory,});

  CategoryModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    if (json['subCategory'] != null) {
      subCategory = [];
      json['subCategory'].forEach((v) {
        subCategory?.add(SubCategory.fromJson(v));
      });
    }
  }
  num? id;
  String? name;
  List<SubCategory>? subCategory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    if (subCategory != null) {
      map['subCategory'] = subCategory?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class SubCategory {
  SubCategory({
      this.id, 
      this.name, 
      this.image, 
      this.products,});

  SubCategory.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(Products.fromJson(v));
      });
    }
  }
  num? id;
  String? name;
  String? image;
  List<Products>? products;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Products {
  Products({
      this.id, 
      this.name, 
      this.image, 
      this.price, 
      this.quantity,
      this.discountPercentage, 
      this.status,});

  Products.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    quantity = json['quantity'];
    discountPercentage = json['discountPercentage'];
    status = json['status'];
  }
  num? id;
  String? name;
  String? image;
  num? price;
  num? quantity;
  num? discountPercentage;
  bool? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    map['price'] = price;
    map['quantity'] = quantity;
    map['discountPercentage'] = discountPercentage;
    map['status'] = status;
    return map;
  }

}