
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

extension IsArabicExtension on BuildContext {
  bool get isArabic {
    return locale.languageCode == 'ar';
  }
}