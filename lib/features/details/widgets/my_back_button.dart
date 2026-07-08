import 'package:bookia/core/constants/app_images.dart';
import 'package:bookia/core/functions/extentions.dart';
import 'package:bookia/core/functions/navigations.dart';
import 'package:bookia/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pop(context),
      child: context.isArabic
          ? RotatedBox(
              quarterTurns: 2,
              child: CustomSvgPicture(path: AppImages.backSvg),
            )
          : CustomSvgPicture(path: AppImages.backSvg),
    );
  }
}
