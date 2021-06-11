import 'package:flutter/material.dart';
import 'package:trufi_core/entities/plan_entity/plan_entity.dart';
import 'package:trufi_core/models/enums/enums_plan/enums_plan.dart';
import 'package:trufi_core/models/enums/enums_plan/icons/other_icons.dart';
import 'package:trufi_core/pages/home/plan_map/widget/icon_transport.dart';

class ModeLeg extends StatelessWidget {
  final double maxWidth;
  final PlanItineraryLeg leg;
  final String mode;
  final double legLength;
  final int duration;
  final bool isTransitLeg;
  final bool renderModeIcons;

  const ModeLeg({
    Key key,
    this.leg,
    this.mode,
    this.legLength,
    this.duration,
    this.isTransitLeg,
    this.renderModeIcons,
    @required this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth * (legLength.abs() / 100),
      height: 32,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: leg?.route?.color != null
              ? Color(int.tryParse("0xFF${leg.route.color}"))
              : leg.transportMode.backgroundColor,
          borderRadius: BorderRadius.circular(3),
        ),
        child: IconTransport(
          transportMode: leg.transportMode ?? getTransportMode(mode: mode),
          text: '',
          icon:
              // leg.transportMode == TransportMode.bicycle &&
              //         leg.fromPlace.bikeRentalStation != null
              //     ? getBikeRentalNetwork(
              //             leg.fromPlace.bikeRentalStation.networks[0])
              //         .image
              //     :
              mode == 'WAIT' ? waitSvg : null,
        ),
      ),
    );
  }
}

class RouteLeg extends StatelessWidget {
  final double maxWidth;
  final PlanItineraryLeg leg;
  final String mode;
  final double legLength;
  final int duration;
  final bool isTransitLeg;
  final bool renderModeIcons;

  const RouteLeg({
    Key key,
    this.leg,
    this.mode,
    this.legLength,
    this.duration,
    this.isTransitLeg,
    this.renderModeIcons,
    @required this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final perc = legLength.abs() / 100;
    return SizedBox(
      width: maxWidth * (perc < 0.07 ? 0.07 : perc),
      // width: width * (legLength / 100),
      height: 32,
      child: ClipRRect(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: leg?.route?.color != null
                ? Color(int.tryParse("0xFF${leg.route.color}"))
                : leg.transportMode.color,
            borderRadius: BorderRadius.circular(3),
          ),
          child: IconTransport(
            transportMode: leg.transportMode,
            // TODO adapted the color server
            color: leg?.route?.color != null
                ? Color(int.tryParse("0xFF${leg.route.color}"))
                : null,
            icon: (leg?.route?.shortName ?? '').startsWith('RT')
                ? onDemandTaxiSvg(color: 'FFFFFF')
                : null,
            text: leg?.route?.shortName != null
                ? leg.route.shortName
                : leg.transportMode.name,
          ),
        ),
      ),
    );
  }
}
