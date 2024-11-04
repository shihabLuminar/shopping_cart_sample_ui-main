import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shopping_cart_may/model/product_model.dart';
import 'package:sqflite/sqflite.dart';

class CartScreenController with ChangeNotifier {
  late Database database;

  Future initDb() async {
    database = await openDatabase("cartdb.db", version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Cart (id INTEGER PRIMARY KEY, name TEXT, qty INTEGER, description TEXT, image TEXT)');
    });
  }

  Future getAllProducts() async {
    var storedProducts = await database.rawQuery('SELECT * FROM Cart');
    log(storedProducts.toString());
  }

  Future addProduct(ProductModel selectedProduct) async {
    await database.rawInsert(
        'INSERT INTO Cart(name, qty, description,image) VALUES(?, ?, ?,?)', [
      selectedProduct.title,
      1,
      selectedProduct.description,
      selectedProduct.image
    ]);
  }

  incrementQty() {}
  decrementQty() {}
  removeProduct() {}
}
