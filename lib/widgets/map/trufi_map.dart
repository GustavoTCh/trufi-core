import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:trufi_core/blocs/custom_layer/custom_layers_cubit.dart';
import 'package:trufi_core/blocs/gps_location/location_provider_cubit.dart';
import 'package:trufi_core/blocs/preferences_cubit.dart';

import '../../trufi_configuration.dart';
import 'trufi_map_controller.dart';
import 'utils/trufi_map_utils.dart';

typedef LayerOptionsBuilder = List<LayerOptions> Function(BuildContext context);

class TrufiMap extends StatelessWidget {
  const TrufiMap({
    Key key,
    @required this.controller,
    @required this.layerOptionsBuilder,
    this.onTap,
    this.onLongPress,
    this.onPositionChanged,
  }) : super(key: key);

  final TrufiMapController controller;
  final LayerOptionsBuilder layerOptionsBuilder;
  final TapCallback onTap;
  final LongPressCallback onLongPress;
  final PositionCallback onPositionChanged;

  @override
  Widget build(BuildContext context) {
    final cfg = TrufiConfiguration();
    final currentMapType =
        context.watch<PreferencesCubit>().state.currentMapType;
    final currentLocation =
        context.watch<LocationProviderCubit>().state.currentLocation;
    final activeCustomLayers =
        context.watch<CustomLayersCubit>().activeCustomLayers;
    return FlutterMap(
      mapController: controller.mapController,
      options: MapOptions(
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        minZoom: cfg.map.onlineMinZoom,
        maxZoom: cfg.map.onlineMaxZoom,
        zoom: cfg.map.onlineZoom,
        onTap: onTap,
        onLongPress: onLongPress,
        center: cfg.map.center,
        onPositionChanged: (
          MapPosition position,
          bool hasGesture,
        ) {
          if (onPositionChanged != null) {
            Future.delayed(Duration.zero, () {
              onPositionChanged(position, hasGesture);
            });
          }
        },
      ),
      layers: [
        tileHostingTileLayerOptions(
          getTilesEndpointForMapType(currentMapType),
          tileProviderKey: cfg.map.mapTilerKey,
        ),
        ...activeCustomLayers,
        buildYourLocationMarkerOption(currentLocation),
        ...layerOptionsBuilder(context)
      ],
    );
  }
}
