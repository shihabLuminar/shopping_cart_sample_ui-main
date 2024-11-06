import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shopping_cart_may/model/product_model.dart';
import 'package:sqflite/sqflite.dart';

class CartScreenController with ChangeNotifier {
  double totalCartValue = 0.00;
  static late Database database;
  List<Map<String, dynamic>> storedProducts = [];

  static Future initDb() async {
    database = await openDatabase("cartdb3.db", version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Cart (id INTEGER PRIMARY KEY, name TEXT, qty INTEGER, amount REAL, image TEXT,productId INTEGER)');
    });
  }

  Future getAllProducts() async {
    storedProducts = await database.rawQuery('SELECT * FROM Cart');
    log(storedProducts.toString());
    caculateTotalAmnt();
    notifyListeners();
  }

  Future addProduct(ProductModel selectedProduct) async {
    // for (int i = 0; i < storedProducts.length; i++) {
    //   if (selectedProduct.id == storedProducts[i]["productId"]) {
    //     alreadyInCart = true;
    //   }
    // }

    bool alreadyInCart = storedProducts.any(
      (element) => selectedProduct.id == element["productId"],
    );

    if (alreadyInCart) {
      log("already in cart");
    } else {
      await database.rawInsert(
          'INSERT INTO Cart(name, qty, amount,image,productId) VALUES(?, ?, ?,?,?)',
          [
            selectedProduct.title,
            1,
            selectedProduct.price,
            selectedProduct.image,
            selectedProduct.id
          ]);
    }
  }

  incrementQty({required int currentQty, required int id}) {
    database
        .rawUpdate('UPDATE Cart SET qty = ? WHERE id = ?', [++currentQty, id]);
    getAllProducts();
  }

  decrementQty({required int currentQty, required int id}) {
    if (currentQty > 1) {
      database.rawUpdate(
          'UPDATE Cart SET qty = ? WHERE id = ?', [--currentQty, id]);
      getAllProducts();
    } else {}
  }

  Future removeProduct(int productId) async {
    await database.rawDelete('DELETE FROM Cart WHERE id = ?', [productId]);
    getAllProducts();
  }

  void caculateTotalAmnt() {
    totalCartValue = 0.00;

    for (var element in storedProducts) {
      totalCartValue = totalCartValue + (element["qty"] * element["amount"]);
    }

    log(totalCartValue.toString());
  }
}
