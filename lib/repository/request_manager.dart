import 'package:async/async.dart';
import 'package:trufi_core/blocs/location_search_bloc.dart';
import 'package:trufi_core/blocs/locations/favorite_locations_cubit/favorite_locations_cubit.dart';
import 'package:trufi_core/trufi_models.dart';

abstract class RequestManager {
  Future<List<TrufiPlace>> fetchLocations(
    FavoriteLocationsCubit favoriteLocationsCubit,
    LocationSearchBloc locationSearchBloc,
    String query, {
    int limit,
    String correlationId,
  });

  CancelableOperation<Plan> fetchTransitPlan(
    TrufiLocation from,
    TrufiLocation to,
    String correlationId,
  );

  CancelableOperation<Plan> fetchCarPlan(
    TrufiLocation from,
    TrufiLocation to,
    String correlationId,
  );

  CancelableOperation<Ad> fetchAd(
    TrufiLocation to,
    String correlationId,
  );
}
