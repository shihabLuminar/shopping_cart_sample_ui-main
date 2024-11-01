import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_cart_may/model/product_model.dart';

class ProductDetailsScreenController with ChangeNotifier {
  ProductModel? product;
  bool isLoading = false;

  getProductDetails(int productId) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse("https://fakestoreapi.com/products/$productId");

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        product = singleProductmodel(response.body);
      }
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }
}
