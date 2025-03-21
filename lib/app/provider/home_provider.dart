import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class HomeProvider extends ChangeNotifier {
  List<CategoryModel> categories = [];
  List<SubCategory> subCategories = [];
  List<Products> products = [];
  SubCategory? selectedSubCategory;
  bool isLoading = true;
  CategoryModel? selectedCategory;
  Future<void> fetchCategories() async {
    final url = Uri.parse('https://tp-flutter-test.vercel.app/v1/category');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        categories = data.map((e) => CategoryModel.fromJson(e)).toList();
        if (categories.isNotEmpty) {
          setSelectedCategory(categories.first);
          setSelectedSubCategory(categories.first.subCategory!.first);
        }
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
    isLoading = false;
    notifyListeners();
  }
  void setSelectedCategory(CategoryModel? category) {
    selectedCategory = category;
    notifyListeners();
  }
  void setSelectedSubCategory(SubCategory subCategory) {
    selectedSubCategory = subCategory;
    log(subCategory.id.toString());
    fetchProducts(int.parse(subCategory.id.toString()));
    notifyListeners();
  }

  void fetchProducts(int subCategoryId) {
    products = categories
        .expand((category) => category.subCategory ?? <SubCategory>[]) // Get all subcategories
        .where((subCategory) => subCategory.id == subCategoryId) // Filter by subCategoryId
        .expand((subCategory) => subCategory.products ?? <Products>[]) // Get products in the matching subcategory
        .toList(); // Convert to List<Products>

    notifyListeners();
  }



  List getFilteredProducts() {
    if (selectedCategory == null) {
      return categories
          .expand((category) => category.subCategory ?? [])
          .expand((subCategory) => subCategory.products ?? [])
          .toList();
    } else {
      return selectedCategory!.subCategory
          ?.expand((subCategory) => subCategory.products ?? [])
          .toList() ?? [];
    }
  }
  /// **Calculate total quantity of items in a category**
  int getTotalCategoryQuantity(CategoryModel category) {
    return (category.subCategory ?? [])
        .map((sub) => getTotalSubCategoryQuantity(sub))
        .fold(0, (sum, quantity) => sum + quantity);
  }
  int getCategoryProductCount(CategoryModel category) {
    return category.subCategory
        ?.expand((sub) => sub.products ?? [])
        .length ??
        0;
  }


  /// **Calculate total quantity of items in a subcategory**
  int getTotalSubCategoryQuantity(SubCategory subCategory) {
    return (subCategory.products ?? [])
        .map((product) => product.quantity ?? 0)
        .fold(0, (sum, quantity) => sum + int.parse(quantity.toString()));
  }
}
