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
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return CartItemWidget(
                    title: cartScreenController.storedProducts[index]["name"],
                    desc: cartScreenController.storedProducts[index]
                        ["description"],
                    qty: cartScreenController.storedProducts[index]["qty"]
                        .toString(),
                    image: cartScreenController.storedProducts[index]["image"],
                    onIncrement: () {
                      context.read<CartScreenController>().incrementQty();
                    },
                    onDecrement: () {
                      context.read<CartScreenController>().decrementQty();
                    },
                    onRemove: () {
                      context.read<CartScreenController>().removeProduct(
                          cartScreenController.storedProducts[index]["id"]);
                    },
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 15),
                itemCount: cartScreenController.storedProducts.length)),
      ),
    );
  }
}
