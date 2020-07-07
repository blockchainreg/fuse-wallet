import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:digitalrand/redux/actions/user_actions.dart';
import 'package:digitalrand/redux/actions/cash_wallet_actions.dart';
import 'package:digitalrand/models/app_state.dart';
import 'package:digitalrand/screens/routes.gr.dart';
import 'package:redux/redux.dart';

class SplashViewModel extends Equatable {
  final String privateKey;
  final String jwtToken;
  final bool isLoggedOut;
  final Function() loginAgain;
  final Function() setDeviceIdCall;
  final Function(VoidCallback successCallback) createLocalAccount;

  SplashViewModel(
      {this.privateKey,
      this.jwtToken,
      this.isLoggedOut,
      this.createLocalAccount,
      this.loginAgain,
      this.setDeviceIdCall});

  static SplashViewModel fromStore(Store<AppState> store) {
    return SplashViewModel(
        privateKey: store.state.userState.privateKey,
        jwtToken: store.state.userState.jwtToken,
        isLoggedOut: store.state.userState.isLoggedOut ?? false,
        createLocalAccount: (VoidCallback successCallback) {
          store.dispatch(createLocalAccountCall(successCallback));
        },
        setDeviceIdCall: () {
          store.dispatch(setDeviceId(false));
        },
        loginAgain: () {
          store.dispatch(reLoginCall());
          store.dispatch(getWalletAddressessCall());
          store.dispatch(identifyCall());
          Router.navigator.pushNamedAndRemoveUntil(
              Router.cashHomeScreen, (Route<dynamic> route) => false);
        });
  }

  @override
  List<Object> get props => [privateKey, jwtToken, isLoggedOut];
}
