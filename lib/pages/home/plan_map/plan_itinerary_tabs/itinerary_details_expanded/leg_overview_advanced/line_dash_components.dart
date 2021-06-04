import 'package:flutter/material.dart';
import 'package:trufi_core/blocs/configuration/configuration_cubit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trufi_core/entities/plan_entity/plan_entity.dart';
import 'package:trufi_core/models/enums/enums_plan/enums_plan.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/enums/enums_plan/icons/other_icons.dart';

import '../../transport_icon_detail.dart';

class TransportDash extends StatelessWidget {
  final double height;
  final double dashWidth;
  final PlanItineraryLeg leg;
  final bool isNextTransport;
  final bool isFirstTransport;

  const TransportDash({
    @required this.leg,
    this.isNextTransport = false,
    this.isFirstTransport = false,
    this.height = 1,
    this.dashWidth = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = TrufiLocalization.of(context);
    final configuration = context.read<ConfigurationCubit>().state;
    return Column(
      children: [
        DashLinePlace(
          date: leg.startTimeString.toString(),
          location: leg.fromPlace.name.toString(),
          color: leg.transportMode.color,
          child: isFirstTransport
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: FittedBox(child: configuration.markers.fromMarker),
                )
              : null,
        ),
        SeparatorPlace(
          color: leg.transportMode.color,
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LegTransportIcon(leg: leg),
                    Text(
                      '  ${leg.durationLeg(localization).toString()}',
                      style: theme.primaryTextTheme.bodyText1,
                    ),
                    Text(
                      ' (${leg.distanceString(localization)})',
                      style: theme.primaryTextTheme.bodyText1,
                    ),
                  ],
                ),
                if (configuration.planItineraryLegBuilder != null)
                  configuration.planItineraryLegBuilder(context, leg),
              ],
            ),
          ),
        ),
        if (isNextTransport)
          DashLinePlace(
            date: leg.endTimeString.toString(),
            location: leg.fromPlace.name.toString(),
            color: leg.transportMode.color,
          ),
      ],
    );
  }
}

class WalkDash extends StatelessWidget {
  final PlanItineraryLeg leg;
  const WalkDash({
    Key key,
    @required this.leg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = TrufiLocalization.of(context);
    return Row(
      children: [
        SeparatorPlace(
          color: leg.transportMode.color,
          separator: Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            height: 19,
            width: 19,
            child: walkSvg,
          ),
          child: Text(
              '${localization.commonWalk} ${leg.durationLeg(localization)} (${leg.distanceString(localization)})'),
        ),
      ],
    );
  }
}

class WaitDash extends StatelessWidget {
  final PlanItineraryLeg legBefore;
  final PlanItineraryLeg legAfter;
  const WaitDash({Key key, this.legBefore, this.legAfter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = TrufiLocalization.of(context);
    return Column(
      children: [
        DashLinePlace(
          date: legBefore.endTimeString.toString(),
          location: legBefore.toPlace.name,
          color: Colors.grey,
        ),
        SeparatorPlace(
          color: Colors.grey,
          separator: Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            height: 20,
            width: 20,
            child: waitSvg,
          ),
          child: Text(
              "${localization.commonWait} (${localization.instructionDurationMinutes(legAfter.startTime.difference(legBefore.endTime).inMinutes)})"),
        ),
      ],
    );
  }
}

class SeparatorPlace extends StatelessWidget {
  final Widget child;
  final Widget separator;
  final Color color;

  const SeparatorPlace({
    Key key,
    @required this.child,
    this.color,
    this.separator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 52),
        SizedBox(
          height: 50,
          width: 20,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: 3,
                  color: color ?? Colors.black,
                ),
              ),
              if (separator != null) separator,
              Expanded(
                child: Container(
                  width: 3,
                  color: color ?? Colors.black,
                ),
              )
            ],
          ),
        ),
        const SizedBox(width: 5),
        if (child != null) child,
      ],
    );
  }
}

class DashLinePlace extends StatelessWidget {
  final String date;
  final String location;
  final Color color;
  final Widget child;

  const DashLinePlace({
    Key key,
    @required this.date,
    @required this.location,
    this.child,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(
            date,
            style: theme.primaryTextTheme.bodyText1,
          ),
        ),
        if (child == null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              Icons.circle,
              size: 18,
              color: color,
            ),
          )
        else
          child,
        Expanded(
          child: Text(
            location,
            style: theme.primaryTextTheme.bodyText1,
          ),
        ),
      ],
    );
  }
}
