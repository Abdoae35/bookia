import 'package:bookia/core/constants/app_images.dart';
import 'package:bookia/core/routes/routes.dart';
import 'package:bookia/core/styles/colors.dart';
import 'package:bookia/core/styles/text_styles.dart';
import 'package:bookia/core/widgets/custom_svg_picture.dart';
import 'package:bookia/core/widgets/dialogs.dart';
import 'package:bookia/core/widgets/shimmer/shimmer_list_view.dart';
import 'package:bookia/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:bookia/features/cart/presentation/cubit/cart_state.dart';
import 'package:bookia/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:bookia/core/widgets/main_button.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentColor,
      appBar: AppBar(
        backgroundColor: AppColors.accentColor,
        title: Text('My Cart'),
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoadedState) {
            var cubit = context.read<CartCubit>();
            if (cubit.cartItems.isNotEmpty) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: MainButton(
                    text: 'Checkout',
                    onPressed: () {
                      context.push(
                        Routes.placeOrder,
                        extra: {'total': cubit.total ?? '0', 'cubit': cubit},
                      );
                    },
                  ),
                ),
              );
            }
          }
          return const SizedBox.shrink();
        },
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoadedState) {
            var cubit = context.read<CartCubit>();

            // Handle empty cart
            if (cubit.cartItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomSvgPicture(
                      path: AppImages.cartSvg,
                      height: 100,
                      width: 100,
                      color: AppColors.darkGreyColor,
                    ),
                    Gap(20),
                    Text('Your cart is empty', style: TextStyles.body),
                  ],
                ),
              );
            }

            // Handle normal cart
            return ListView.separated(
              itemCount: cubit.cartItems.length,
              padding: EdgeInsets.all(20),
              separatorBuilder: (BuildContext context, int index) {
                return Gap(16);
              },
              itemBuilder: (BuildContext context, int index) {
                return CartItemWidget(
                  item: cubit.cartItems[index],
                  onDelete: () {
                    cubit.removeFromCart(cubit.cartItems[index].itemId ?? 0);
                  },
                  onDecrement: () {
                    if ((cubit.cartItems[index].itemQuantity ?? 0) > 1) {
                      cubit.updateCart(
                        cubit.cartItems[index].itemId ?? 0,
                        (cubit.cartItems[index].itemQuantity ?? 0) - 1,
                      );
                    } else {
                      cubit.removeFromCart(cubit.cartItems[index].itemId ?? 0);
                    }
                  },
                  onIncrement: () {
                    if ((cubit.cartItems[index].itemQuantity ?? 0) <
                        (cubit.cartItems[index].itemProductStock ?? 0)) {
                      cubit.updateCart(
                        cubit.cartItems[index].itemId ?? 0,
                        (cubit.cartItems[index].itemQuantity ?? 0) + 1,
                      );
                    } else {
                      showMyDialog(
                        context,
                        "You can't add more than the stock",
                      );
                    }
                  },
                );
              },
            );
          } else {
            // Handle loading state
            return ShimmerListView(
              itemCount: 3,
              padding: EdgeInsets.all(20),
              itemHeight: 120,
              separatorHeight: 20,
            );
          }
        },
      ),
    );
  }
}
