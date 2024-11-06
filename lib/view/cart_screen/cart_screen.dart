import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_may/controller/cart_screen_controller.dart';
import 'package:shopping_cart_may/view/cart_screen/widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<CartScreenController>().getAllProducts();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartScreenController = context.watch<CartScreenController>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Cart"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return CartItemWidget(
                          title: cartScreenController.storedProducts[index]
                              ["name"],
                          amount: cartScreenController.storedProducts[index]
                              ["amount"],
                          qty: cartScreenController.storedProducts[index]["qty"]
                              .toString(),
                          image: cartScreenController.storedProducts[index]
                              ["image"],
                          onIncrement: () {
                            context.read<CartScreenController>().incrementQty(
                                currentQty: cartScreenController
                                    .storedProducts[index]["qty"],
                                id: cartScreenController.storedProducts[index]
                                    ["id"]);
                          },
                          onDecrement: () {
                            context.read<CartScreenController>().decrementQty(
                                currentQty: cartScreenController
                                    .storedProducts[index]["qty"],
                                id: cartScreenController.storedProducts[index]
                                    ["id"]);
                          },
                          onRemove: () {
                            context.read<CartScreenController>().removeProduct(
                                cartScreenController.storedProducts[index]
                                    ["id"]);
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15),
                      itemCount: cartScreenController.storedProducts.length),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Amount :",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text(
                            "\$ ${cartScreenController.totalCartValue.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Text(
                              "CHECKOUT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.shopping_cart_checkout_rounded,
                              color: Colors.white,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
