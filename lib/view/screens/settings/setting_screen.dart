import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/app_bar_base.dart';
import 'package:flutter_grocery/view/base/custom_dialog.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/screens/settings/widget/currency_dialog.dart';
import 'package:provider/provider.dart';

import '../../../provider/auth_provider.dart';
import '../menu/widget/acount_delete_dialog.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<SplashProvider>(context, listen: false).setFromSetting(true);
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()? null: (ResponsiveHelper.isDesktop(context)? MainAppBar(): AppBarBase()) as PreferredSizeWidget?,
      body: Center(
        child: Container(
          width: 1170,
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            children: [
              SwitchListTile(
                value: Provider.of<ThemeProvider>(context).darkTheme,
                onChanged: (bool isActive) =>Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                title: Text(getTranslated('dark_theme', context)!, style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),

              TitleButton(
                icon: Icons.language,
                title: getTranslated('choose_language', context),
                onTap: () => showAnimatedDialog(context, CurrencyDialog()),
              ),

              _authProvider.isLoggedIn() ? ListTile(
                onTap: () {
                  showAnimatedDialog(context,
                      AccountDeleteDialog(
                        icon: Icons.question_mark_sharp,
                        title: getTranslated('are_you_sure_to_delete_account', context),
                        description: getTranslated('it_will_remove_your_all_information', context),
                        onTapFalseText:getTranslated('no', context),
                        onTapTrueText: getTranslated('yes', context),
                        isFailed: true,
                        onTapFalse: () => Navigator.of(context).pop(),
                        onTapTrue: () => _authProvider.deleteUser(context),
                      ),
                      dismissible: false,
                      isFlip: true);
                },
                leading: Icon(Icons.delete, size: 25),
                title: Text(
                  getTranslated('delete_account', context)!,
                  style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                  ),
                ),
              ) : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

}

class TitleButton extends StatelessWidget {
  final IconData icon;
  final String? title;
  final Function onTap;
  TitleButton({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title!, style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      onTap: onTap as void Function()?,
    );
  }
}

