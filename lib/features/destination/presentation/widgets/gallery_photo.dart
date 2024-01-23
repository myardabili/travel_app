// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travel_app/api/urls.dart';
import 'package:travel_app/features/destination/presentation/widgets/circle_loading.dart';

class GalleryPhoto extends StatelessWidget {
  final List<String> images;
  const GalleryPhoto({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    return Stack(
      children: [
        PhotoViewGallery.builder(
          pageController: pageController,
          scrollPhysics: const BouncingScrollPhysics(),
          itemCount: images.length,
          loadingBuilder: (context, event) {
            return const CircleLoading();
          },
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: ExtendedNetworkImageProvider(
                URLs.image(images[index]),
              ),
              initialScale: PhotoViewComputedScale.contained * 0.8,
              heroAttributes: PhotoViewHeroAttributes(tag: images[index]),
            );
          },
        ),
        Positioned(
          right: 0,
          left: 0,
          bottom: 30,
          child: Center(
            child: SmoothPageIndicator(
              controller: pageController,
              count: images.length,
              effect: WormEffect(
                dotColor: Colors.grey[300]!,
                activeDotColor: Theme.of(context).primaryColor,
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.topRight,
          child: CloseButton(),
        ),
      ],
    );
  }
}
