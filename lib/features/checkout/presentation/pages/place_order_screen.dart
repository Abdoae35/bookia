import 'package:bookia/core/constants/app_images.dart';
import 'package:bookia/core/styles/colors.dart';
import 'package:bookia/core/styles/text_styles.dart';
import 'package:bookia/core/widgets/custom_svg_picture.dart';
import 'package:bookia/core/widgets/dialogs.dart';
import 'package:bookia/core/widgets/main_button.dart';
import 'package:bookia/core/widgets/shimmer/shimmer_list_view.dart';
import 'package:bookia/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:bookia/features/cart/presentation/cubit/cart_state.dart';
import 'package:bookia/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class PlaceOrderScreen extends StatelessWidget {
  const PlaceOrderScreen({super.key,required this.total});
  final String total;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentColor,
      appBar: AppBar(
        backgroundColor: AppColors.accentColor,
        title: Text('Place Order    '),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:', style: TextStyles.body),
                  BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      var total = context.read<CartCubit>().total ?? '0';
                      return Text('\$$total', style: TextStyles.body);
                    },
                  ),
                ],
              ),
              Gap(16),
              MainButton(text: 'check out', onPressed: () {}),
            ],
          ),
        ),
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is CartLoadingState) {
            // Handle loading state
            return ShimmerListView(
              itemCount: 3,
              padding: EdgeInsets.all(20),
              itemHeight: 120,
              separatorHeight: 20,
            );
          }

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
                    showMyDialog(context, "You can't add more than the stock");
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
