import 'package:bookia/core/services/apis/apis.dart';
import 'package:bookia/core/services/apis/dio_provider.dart';

class CartRepo {
  // make three function to add to cart, remove from cart and get cart items

  static getCart() async {
    var response = await DioProvider.get(endpoint: Apis.showCart);
  }

  static addToCart() {}
  static removeFromCart() {}

  static updateCart() {}
}
