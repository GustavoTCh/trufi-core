import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trufi_core/blocs/theme_bloc.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';

import 'package:trufi_core/entities/plan_entity/plan_entity.dart';
import 'package:trufi_core/pages/home/plan_map/plan_itinerary_tabs/itinarary_details_collapsed/itinerary_summary_advanced.dart';
import 'package:trufi_core/pages/home/plan_map/plan_itinerary_tabs/itinerary_details_expanded/leg_overview_advanced/leg_overview_advanced.dart';

import '../plan.dart';

class CustomItinerary extends StatefulWidget {
  final PlanPageController planPageController;
  const CustomItinerary({Key key, @required this.planPageController})
      : super(key: key);

  @override
  _CustomItineraryState createState() => _CustomItineraryState();
}

class _CustomItineraryState extends State<CustomItinerary> {
  PlanItinerary currentPlanItinerary;
  @override
  void initState() {
    currentPlanItinerary = widget.planPageController.selectedItinerary;
    super.initState();
    widget.planPageController.outSelectedItinerary.listen((selectedItinerary) {
      if (mounted) {
        setState(() {
          currentPlanItinerary = selectedItinerary;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeCubit>().state.bottomBarTheme;
    final localization = TrufiLocalization.of(context);
    return Theme(
      data: theme,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: currentPlanItinerary == null
            ? ListView.builder(
                itemCount: widget.planPageController.plan.itineraries.length,
                itemBuilder: (buildContext, index) {
                  final itinerary =
                      widget.planPageController.plan.itineraries[index];
                  return GestureDetector(
                    onTap: () {
                      widget.planPageController.inSelectedItinerary
                          .add(itinerary);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Divider(),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 45.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                if (itinerary.hasAdvencedData)
                                  Text(
                                    "${itinerary.startTimeHHmm} - ${itinerary.endTimeHHmm}    ",
                                    style: theme.primaryTextTheme.bodyText1
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    if (itinerary.hasAdvencedData)
                                      Text(
                                        "${itinerary.durationTripString(localization)} ",
                                        style: theme.primaryTextTheme.bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w500),
                                      )
                                    else
                                      Text(
                                        "${localization.instructionDurationMinutes(itinerary.time)} ",
                                        style: theme.primaryTextTheme.bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                    Text(
                                      "(${itinerary.getDistanceString(localization)})",
                                      style: theme.primaryTextTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ItinerarySummaryAdvanced(itinerary: itinerary),
                        ],
                      ),
                    ),
                  );
                })
            : ListView(
                children: [
                  Row(
                    children: [
                      BackButton(
                        onPressed: () {
                          widget.planPageController.inSelectedItinerary
                              .add(null);
                        },
                      ),
                    ],
                  ),
                  LegOverviewAdvanced(itinerary: currentPlanItinerary),
                ],
              ),
      ),
    );
  }
}
