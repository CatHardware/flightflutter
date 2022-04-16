import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/device/constants.dart';
import '../google_maps_view_model.dart';
import '../model/fligt_map_model.dart';
import '../vm/maps_vm.dart';
import 'widget/card/pet_card.dart';
import 'widget/divider/row_divider.dart';
import 'widget/image/cached_image.dart';

class GoogleMapsViews extends GoogleMapsViewModel {
  final MapsViewModel mapsViewModel = MapsViewModel();
  @override
  Widget build(BuildContext context) {
    // Replace this with your build function
    return Scaffold(
      floatingActionButton: buildFloatingActionButton,
      body: Stack(
        children: [
          buildGoogleMap,
          bottomListView,
          buildAppBar,
        ],
      ),
    );
  }

  Widget get buildAppBar {
    return Positioned(
      left: 0,
      right: 0,
      top: pageHeight(context) * 0.01,
      height: 100,
      child: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Observer(builder: (_) => Text(mapsViewModel.title ?? "Hello")),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => initMapItemList());
  }

  Widget get bottomListView => Positioned(
        left: -(pageWidth(context) * 0.05),
        right: 0,
        bottom: pageHeight(context) * 0.05,
        height: 100,
        child: flightList.isEmpty ? loadingWidget : buildFligtListView(),
      );

  Widget get loadingWidget => const Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.amber)),
      );

  Widget buildFligtListView() {
    return PageView.builder(
      controller: PageController(viewportFraction: 0.8),
      onPageChanged: (index) {
        navigateToRoot(index);
        mapsViewModel.changeAppBarName(flightList[index].country ?? "");
      },
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return buildPathCard(flightList[index]);
      },
      itemCount: flightList.length,
    );
  }

  Widget buildPathCard(FlightMap item) {
    return PetCard(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            enableDrag: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
            builder: (context) {
              return _bottomSheet(item.detail);
            });
      },
      imageUrl: item.detail!.photoUrl,
      title: item.country,
    );
  }

  Widget _bottomSheet(Detail? detail) => Column(
        children: [
          RowDivider(indent: 0.4, colors: Colors.grey, thick: 3),
          FlightCacheImage(
            imageUrl: detail!.photoUrl,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: AutoSizeText(
                '${detail.description}',
                maxFontSize: 15,
                minFontSize: 10,
              ),
            ),
          )
        ],
      );

  GoogleMap get buildGoogleMap => GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: kLake,
        onMapCreated: (map) {
          controller = map;
          createMarkerImageFromAsset(context);

          setState(() {});
        },
        markers: _createMarker(),
      );

  FloatingActionButton get buildFloatingActionButton => FloatingActionButton(
        onPressed: () {
          controller!.animateCamera(CameraUpdate.newLatLng(AppConstant.TURKEY_CENTER_LAT_LONG));
        },
      );
}

extension _GoogleMapsViewsMarkers on GoogleMapsViews {
  Future<void> createMarkerImageFromAsset(context) async {
    final ImageConfiguration imageConfiguration = createLocalImageConfiguration(context);
    var bitmap = await BitmapDescriptor.fromAssetImage(imageConfiguration, 'assets/images/dog.png');
    dogIcon = bitmap;
    setState(() {});
  }

  Set<Marker> _createMarker() {
    return flightList
        .map((e) => Marker(
            markerId: MarkerId(e.hashCode.toString()),
            position: e.latLong,
            icon: dogIcon ?? BitmapDescriptor.defaultMarker,
            zIndex: 10,
            infoWindow: InfoWindow(title: e.country)))
        .toSet();
  }
}
