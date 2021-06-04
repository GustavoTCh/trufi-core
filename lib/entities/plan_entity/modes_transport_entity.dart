part of 'plan_entity.dart';

class ModesTransportEntity {
  static const _walkPlan = 'walkPlan';
  static const _bikePlan = 'bikePlan';
  static const _bikeAndPublicPlan = 'bikeAndPublicPlan';
  static const _bikeParkPlan = 'bikeParkPlan';
  static const _carPlan = 'carPlan';
  static const _parkRidePlan = 'parkRidePlan';

  final PlanEntity walkPlan;
  final PlanEntity bikePlan;
  final PlanEntity bikeAndPublicPlan;
  final PlanEntity bikeParkPlan;
  final PlanEntity carPlan;
  final PlanEntity parkRidePlan;

  const ModesTransportEntity({
    this.walkPlan,
    this.bikePlan,
    this.bikeAndPublicPlan,
    this.bikeParkPlan,
    this.carPlan,
    this.parkRidePlan,
  });

  factory ModesTransportEntity.fromJson(Map<String, dynamic> json) =>
      ModesTransportEntity(
        walkPlan: json[_walkPlan] != null
            ? PlanEntity.fromJson(json[_walkPlan] as Map<String, dynamic>)
            : null,
        bikePlan: json[_bikePlan] != null
            ? PlanEntity.fromJson(json[_bikePlan] as Map<String, dynamic>)
            : null,
        bikeAndPublicPlan: json[_bikeAndPublicPlan] != null
            ? PlanEntity.fromJson(
                json[_bikeAndPublicPlan] as Map<String, dynamic>)
            : null,
        bikeParkPlan: json[_bikeParkPlan] != null
            ? PlanEntity.fromJson(json[_bikeParkPlan] as Map<String, dynamic>)
            : null,
        carPlan: json[_carPlan] != null
            ? PlanEntity.fromJson(json[_carPlan] as Map<String, dynamic>)
            : null,
        parkRidePlan: json[_parkRidePlan] != null
            ? PlanEntity.fromJson(json[_parkRidePlan] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        _walkPlan: walkPlan?.toJson(),
        _bikePlan: bikePlan?.toJson(),
        _bikeAndPublicPlan: bikeAndPublicPlan?.toJson(),
        _bikeParkPlan: bikeParkPlan?.toJson(),
        _carPlan: carPlan?.toJson(),
        _parkRidePlan: parkRidePlan?.toJson(),
      };

  PlanEntity get bikeAndVehicle => bikeAndPublicPlan.copyWith(itineraries: [
        ...filterOnlyBikeAndWalk(bikeParkPlan?.itineraries ?? []),
        ...filterOnlyBikeAndWalk(bikeAndPublicPlan?.itineraries ?? [])
      ]);

  bool get existWalkPlan =>
      (walkPlan?.itineraries?.isNotEmpty ?? false) &&
      walkPlan.itineraries[0].walkDistance <
          PayloadDataPlanState.maxWalkDistance;

  bool get existBikePlan =>
      (bikePlan?.itineraries?.isNotEmpty ?? false) &&
      !bikePlan.itineraries.every((itinerary) => itinerary.legs
          .every((leg) => leg.transportMode == TransportMode.walk)) &&
      bikePlan.itineraries[0].totalBikingDistance <
          PayloadDataPlanState.suggestBikeMaxDistance;

  bool get existBikeAndVehicle =>
      _bikeAndPublicPlanHasItineraries || _bikeParkPlanHasItineraries;

  bool get existCarPlan => carPlan?.itineraries?.isNotEmpty ?? false;

  bool get existParkRidePlan => parkRidePlan?.itineraries?.isNotEmpty ?? false;

  bool get availableModesTransport =>
      existWalkPlan ||
      existBikePlan ||
      existBikeAndVehicle ||
      existCarPlan ||
      existParkRidePlan;

  Widget getIconBikePublic() {
    final publicModes = filterOnlyBikeAndWalk(bikeParkPlan.itineraries)[0]
        .legs
        .where(
          (element) =>
              element.transportMode != TransportMode.walk &&
              element.transportMode != TransportMode.bicycle,
        )
        .toList();
    if (publicModes.isNotEmpty) {
      return publicModes[0].transportMode.image;
    }
    return Container();
  }

  bool get _bikeAndPublicPlanHasItineraries =>
      hasItinerariesContainingPublicTransit(bikeAndPublicPlan);

  bool get _bikeParkPlanHasItineraries =>
      hasItinerariesContainingPublicTransit(bikeParkPlan);
}
