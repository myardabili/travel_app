// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/features/destination/presentation/widgets/circle_loading.dart';
import 'package:travel_app/features/destination/presentation/widgets/parallax_horiz_delegate.dart';

class TopDestinationImage extends StatelessWidget {
  final imageKey = GlobalKey();
  final String url;
  TopDestinationImage({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: ParallaxHorizDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: imageKey,
      ),
      children: [
        ExtendedImage.network(
          url,
          key: imageKey,
          fit: BoxFit.cover,
          width: double.infinity,
          handleLoadingProgress: true,
          loadStateChanged: (state) {
            if (state.extendedImageLoadState == LoadState.failed) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.black,
                  ),
                ),
              );
            }
            if (state.extendedImageLoadState == LoadState.loading) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[300],
                  child: const CircleLoading(),
                ),
              );
            }
            return null;
          },
        ),
      ],
    );
  }
}
