import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_cart_may/model/product_model.dart';

class HomeScreenController with ChangeNotifier {
  List categoryList = []; // dfghjkl
  bool isLoading = false;
  bool isProductsLoading = false;

  int selectedCategoryIndex = 0;
  List<ProductModel> productList = [];
  getCategories() async {
    final url = Uri.parse("https://fakestoreapi.com/products/categories");

    try {
      isLoading = true;
      notifyListeners();

      var response = await http.get(url);
      if (response.statusCode == 200) {
        print(response.body);
        var covertjson = jsonDecode(response.body);

        categoryList = covertjson;
        categoryList.insert(0, "All"); // ghjkl;adsf

        print('list : $categoryList');
      }
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  onCategorySeleciton(int clickedIndex) async {
    if (selectedCategoryIndex != clickedIndex && isProductsLoading == false) {
      selectedCategoryIndex = clickedIndex;
      notifyListeners();
      await getAllProducts();
    }
  }

  getAllProducts() async {
    isProductsLoading = true;
    notifyListeners();
    final allProductsUrl = Uri.parse("https://fakestoreapi.com/products");

    final productsByCategoryUrl = Uri.parse(
        "https://fakestoreapi.com/products/category/${categoryList[selectedCategoryIndex]}");

    try {
      final response = await http.get(
          selectedCategoryIndex == 0 ? allProductsUrl : productsByCategoryUrl);
      if (response.statusCode == 200) {
        productList = productModelFromJson(response.body);
      }
    } catch (e) {}
    isProductsLoading = false;
    notifyListeners();
  }
}
