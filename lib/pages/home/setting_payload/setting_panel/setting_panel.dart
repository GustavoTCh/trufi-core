import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trufi_core/blocs/payload_data_plan/payload_data_plan_cubit.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/enums/enums_plan/enums_plan.dart';
import 'package:trufi_core/widgets/custom_expanded_tile.dart';
import 'package:trufi_core/widgets/custom_switch_tile.dart';

class SettingPanel extends StatelessWidget {
  static const String route = "/setting-panel";
  static const Divider _divider = Divider(thickness: 2);
  static const Divider _dividerWeight = Divider(thickness: 10);

  const SettingPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = TrufiLocalization.of(context);

    final payloadDataPlanCubit = context.read<PayloadDataPlanCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop(payloadDataPlanCubit.state);
          },
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<PayloadDataPlanCubit, PayloadDataPlanState>(
          builder: (blocContext, state) {
            return ListView(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                CustomExpansionTile(
                  title: "Walking speed",
                  options: WalkingSpeed.values
                      .map(
                        (e) => e.translateValue(localization),
                      )
                      .toList(),
                  textSelected:
                      state.typeWalkingSpeed.translateValue(localization),
                  onChanged: (value) {
                    final WalkingSpeed selected = WalkingSpeed.values
                        .firstWhere((element) =>
                            element.translateValue(localization) == value);
                    payloadDataPlanCubit.setWalkingSpeed(selected);
                  },
                ),
                _divider,
                CustomSwitchTile(
                  title: 'Avoid walking',
                  value: state.avoidWalking,
                  onChanged: (value) =>
                      payloadDataPlanCubit.setAvoidWalking(avoidWalking: value),
                ),
                _dividerWeight,
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      Text('Transport modes', style: theme.textTheme.bodyText1),
                ),
                CustomSwitchTile(
                  title: 'Bus',
                  secondary: Icon(TransportMode.bus.icon),
                  value: state.transportModes.contains(TransportMode.bus),
                  onChanged: (_) {
                    payloadDataPlanCubit.setTransportMode(TransportMode.bus);
                  },
                ),
                _divider,
                CustomSwitchTile(
                  title: 'Commuter train',
                  secondary: Icon(TransportMode.rail.icon),
                  value: state.transportModes.contains(TransportMode.rail),
                  onChanged: (_) {
                    payloadDataPlanCubit.setTransportMode(TransportMode.rail);
                  },
                ),
                _divider,
                CustomSwitchTile(
                  title: 'Metro',
                  secondary: Icon(TransportMode.subway.icon),
                  value: state.transportModes.contains(TransportMode.subway),
                  onChanged: (_) {
                    payloadDataPlanCubit.setTransportMode(TransportMode.subway);
                  },
                ),
                _divider,
                CustomSwitchTile(
                  title: 'Carpool',
                  secondary: Icon(TransportMode.carPool.icon),
                  value: state.transportModes.contains(TransportMode.carPool),
                  onChanged: (_) {
                    payloadDataPlanCubit
                        .setTransportMode(TransportMode.carPool);
                  },
                ),
                _divider,
                CustomSwitchTile(
                  title: 'Sharing',
                  secondary: Icon(TransportMode.bicycle.icon),
                  value: state.transportModes.contains(TransportMode.bicycle),
                  onChanged: (_) {
                    payloadDataPlanCubit
                        .setTransportMode(TransportMode.bicycle);
                  },
                ),
                if (state.transportModes.contains(TransportMode.bicycle))
                  Container(
                    margin: const EdgeInsets.only(left: 55, top: 5, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 5),
                          child: Text('Citybikes',
                              style: theme.textTheme.bodyText1),
                        ),
                        CustomSwitchTile(
                          title: 'RegioRad',
                          secondary: Icon(TransportMode.bicycle.icon),
                          value: state.bikeRentalNetworks
                              .contains(BikeRentalNetwork.regioRad),
                          onChanged: (_) {
                            payloadDataPlanCubit.setBikeRentalNetwork(
                                BikeRentalNetwork.regioRad);
                          },
                        ),
                        CustomSwitchTile(
                          title: 'Taxi',
                          secondary: Icon(TransportMode.bicycle.icon),
                          value: state.bikeRentalNetworks
                              .contains(BikeRentalNetwork.taxi),
                          onChanged: (_) {
                            payloadDataPlanCubit
                                .setBikeRentalNetwork(BikeRentalNetwork.taxi);
                          },
                        ),
                        CustomSwitchTile(
                          title: 'CarSharing',
                          secondary: Icon(TransportMode.bicycle.icon),
                          value: state.bikeRentalNetworks
                              .contains(BikeRentalNetwork.carSharing),
                          onChanged: (_) {
                            payloadDataPlanCubit.setBikeRentalNetwork(
                                BikeRentalNetwork.carSharing);
                          },
                        ),
                      ],
                    ),
                  )
                else
                  Container(),
                CustomSwitchTile(
                  title: 'Avoid transfers',
                  value: state.avoidTransfers,
                  onChanged: (value) => payloadDataPlanCubit.setAvoidTransfers(
                      avoidTransfers: value),
                ),
                _dividerWeight,
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('My modes of transport',
                      style: theme.textTheme.bodyText1),
                ),
                CustomSwitchTile(
                  title: 'Bike',
                  secondary: Icon(TransportMode.bicycle.icon),
                  value: state.includeBikeSuggestions,
                  onChanged: (value) => payloadDataPlanCubit
                      .setIncludeBikeSuggestions(includeBikeSuggestions: value),
                ),
                if (state.includeBikeSuggestions)
                  Container(
                    margin: const EdgeInsets.only(
                      left: 55,
                    ),
                    child: CustomExpansionTile(
                      title: "Biking speed",
                      options: BikingSpeed.values
                          .map(
                            (e) => e.translateValue(localization),
                          )
                          .toList(),
                      textSelected:
                          state.typeBikingSpeed.translateValue(localization),
                      onChanged: (value) {
                        final BikingSpeed selected = BikingSpeed.values
                            .firstWhere((element) =>
                                element.translateValue(localization) == value);
                        payloadDataPlanCubit.setBikingSpeed(selected);
                      },
                    ),
                  )
                else
                  Container(),
                _divider,
                CustomSwitchTile(
                  title: 'Park and Ride',
                  secondary: Icon(TransportMode.bicycle.icon),
                  value: state.includeParkAndRideSuggestions,
                  onChanged: (value) =>
                      payloadDataPlanCubit.setParkRide(parkRide: value),
                ),
                CustomSwitchTile(
                  title: 'Car',
                  secondary: Icon(TransportMode.car.icon),
                  value: state.includeCarSuggestions,
                  onChanged: (value) => payloadDataPlanCubit
                      .setIncludeCarSuggestions(includeCarSuggestions: value),
                ),
                _dividerWeight,
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      Text('Accessibility', style: theme.textTheme.bodyText1),
                ),
                CustomSwitchTile(
                  title: 'Wheelchair',
                  secondary: Icon(TransportMode.car.icon),
                  value: state.wheelchair,
                  onChanged: (value) =>
                      payloadDataPlanCubit.setWheelChair(wheelchair: value),
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }
}
