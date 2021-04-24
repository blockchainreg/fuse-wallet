import 'package:equatable/equatable.dart';
import 'package:fusecash/models/actions/wallet_action.dart';
import 'package:redux/redux.dart';
import 'package:fusecash/models/app_state.dart';
import 'package:fusecash/redux/actions/cash_wallet_actions.dart';

class HomeViewModel extends Equatable {
  final Function(bool initial) onReceiveBranchData;
  final bool showDepositBanner;

  HomeViewModel({
    this.onReceiveBranchData,
    this.showDepositBanner,
  });

  static HomeViewModel fromStore(Store<AppState> store) {
    String communityAddress = store.state.cashWalletState.communityAddress;
    bool isCommunityLoading =
        store.state.cashWalletState.isCommunityLoading ?? false;
    String branchAddress = store.state.cashWalletState.branchAddress;

    final bool isBranchDataReceived =
        store.state.cashWalletState.isBranchDataReceived ?? false;
    final bool isCommunityFetched =
        store.state.cashWalletState.isCommunityFetched ?? false;
    final String walletAddress = store.state.userState.walletAddress;

    final WalletAction walletAction =
        store.state.cashWalletState?.walletActions?.list?.firstWhere(
      (element) => element is CreateWallet,
      orElse: () => null,
    );
    final bool isDepositBanner =
        [true, null].contains(store.state?.cashWalletState?.isDepositBanner);
    final bool showDepositBanner =
        (walletAction != null && walletAction.isConfirmed()) && isDepositBanner;

    return HomeViewModel(
      showDepositBanner: showDepositBanner,
      onReceiveBranchData: (initial) {
        if (!isCommunityLoading && isCommunityFetched && isBranchDataReceived) {
          store.dispatch(switchCommunityCall(branchAddress));
        } else if (initial) {
          if (store.state.cashWalletState.tokens.isEmpty &&
              !isCommunityLoading &&
              isCommunityFetched &&
              isBranchDataReceived) {
            store.dispatch(switchCommunityCall(communityAddress));
          }
          if (!isCommunityLoading &&
              !isBranchDataReceived &&
              !isCommunityFetched &&
              ![null, ''].contains(walletAddress)) {
            store.dispatch(refetchCommunityData());
          }
        }
      },
    );
  }

  @override
  List<Object> get props => [
        showDepositBanner,
      ];
}
