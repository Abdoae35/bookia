import 'package:bookia/features/home/data/models/best_seller_response/product.dart';
import 'package:bookia/features/wishlist/data/repo/wishlist_repo.dart';
import 'package:bookia/features/wishlist/presentation/cubit/wishlist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(WishlistInitialState());

  List<Product> wishlist = [];

  Future<void> getWishlist() async {
    emit(WishlistLoadingState());
    var response = await WishListRepo.getWishlist();
    if (response != null && response.data != null) {
      wishlist = response.data?.data ?? [];
      emit(WishlistSuccessState());
    } else {
      emit(WishlistErrorState(error: "Failed to load wishlist"));
    }
  }

  Future<void> removeFromWishlist(int productId) async {
    //offline Remove 
    //get item that we need 
    var itemToRemove = wishlist.firstWhere((item) => item.id == productId);
    //remove it from the list
    wishlist.remove(itemToRemove);
    //update the state ui
    emit(WishlistLoadingState());

    //send request to the server to remove the item from the wishlist
    var response = await WishListRepo.removeFromWishlist(productId);
    if (response != null && response.data != null) {
      wishlist = response.data?.data ?? [];
      emit(WishlistSuccessState(message: response.message ?? ""));
    } else {
      emit(WishlistErrorState(error: "Failed to update wishlist"));
    }
  }
}
