import 'dart:developer';
import 'package:bookia/core/services/apis/apis.dart';
import 'package:bookia/core/services/apis/dio_provider.dart';
import 'package:bookia/core/services/local/shared_pref.dart';
import 'package:bookia/features/cart/data/models/cart_response/cart_response.dart';

class CartRepo {
  // make three function to add to cart, remove from cart and get cart items

  static Future<CartResponse?> getCart() async {
    try {
      var response = await DioProvider.get(
        endpoint: Apis.showCart,
        headers: {"Authorization": "Bearer ${SharedPref.getToken()}"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CartResponse.fromJson(response.data);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('getCart error: $e');
      return null;
    }
  }

  static Future<CartResponse?> addToCart(int productId) async {
    try {
      var response = await DioProvider.post(
        endpoint: Apis.addToCart,
        headers: {"Authorization": "Bearer ${SharedPref.getToken()}"},
        data: {"product_id": productId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CartResponse.fromJson(response.data);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('addToCart error: $e');
      return null;
    }
  }

  static Future<CartResponse?> removeFromCart(int cartItemId) async {
    try {
      var response = await DioProvider.post(
        endpoint: Apis.removeFromCart,
        headers: {"Authorization": "Bearer ${SharedPref.getToken()}"},
        data: {"cart_item_id": cartItemId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CartResponse.fromJson(response.data);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('removeFromCart error: $e');
      return null;
    }
  }

  static Future<CartResponse?> updateCart(int cartItemId, int quantity) async {
    try {
      var response = await DioProvider.post(
        endpoint: Apis.updateCart,
        headers: {"Authorization": "Bearer ${SharedPref.getToken()}"},
        data: {"cart_item_id": cartItemId, "quantity": quantity},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CartResponse.fromJson(response.data);
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('updateCart error: $e');
      return null;
    }
  }
}
