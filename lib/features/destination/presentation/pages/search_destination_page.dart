import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:travel_app/api/urls.dart';
import 'package:travel_app/common/app_route.dart';
import 'package:travel_app/features/destination/domain/entities/destination_entity.dart';
import 'package:travel_app/features/destination/presentation/bloc/search_destination/search_destination_bloc.dart';
import 'package:travel_app/features/destination/presentation/widgets/circle_loading.dart';
import 'package:travel_app/features/destination/presentation/widgets/parallax_vert_delegate.dart';
import 'package:travel_app/features/destination/presentation/widgets/text_failure.dart';

class SearchDestinationPage extends StatefulWidget {
  const SearchDestinationPage({super.key});

  @override
  State<SearchDestinationPage> createState() => _SearchDestinationPageState();
}

class _SearchDestinationPageState extends State<SearchDestinationPage> {
  final edtSearch = TextEditingController();

  search() {
    if (edtSearch.text == '') return;
    context
        .read<SearchDestinationBloc>()
        .add(OnSearchDestination(edtSearch.text));
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void initState() {
    context.read<SearchDestinationBloc>().add(OnResetSearchDestination());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.only(
          top: 60,
          bottom: 80,
        ),
        child: buildSearch(),
      ),
      bottomSheet: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height - 140,
          color: Colors.white,
          child: BlocBuilder<SearchDestinationBloc, SearchDestinationState>(
            builder: (context, state) {
              if (state is SearchDestinationLoading) {
                return const CircleLoading();
              }
              if (state is SearchDestinationFailure) {
                return TextFailure(message: state.message);
              }
              if (state is SearchDestinationLoaded) {
                List<DestinationEntity> list = state.data;
                return ListView.builder(
                  itemCount: list.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    DestinationEntity destination = list[index];
                    return Container(
                      margin: EdgeInsets.only(
                          bottom: index == list.length - 1 ? 0 : 20),
                      child: itemSearch(destination),
                    );
                  },
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget itemSearch(DestinationEntity destination) {
    final imageKey = GlobalKey();
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoute.detailDestination,
          arguments: destination,
        );
      },
      child: AspectRatio(
        aspectRatio: 2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Builder(builder: (context) {
              return Flow(
                delegate: ParallaxVertDelegate(
                  scrollable: Scrollable.of(context),
                  listItemContext: context,
                  backgroundImageKey: imageKey,
                ),
                children: [
                  ExtendedImage.network(
                    URLs.image(destination.cover),
                    key: imageKey,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    handleLoadingProgress: true,
                    loadStateChanged: (state) {
                      if (state.extendedImageLoadState == LoadState.failed) {
                        return Material(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.black,
                          ),
                        );
                      }
                      if (state.extendedImageLoadState == LoadState.loading) {
                        return Material(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[300],
                          child: const CircleLoading(),
                        );
                      }
                      return null;
                    },
                  ),
                ],
              );
            }),
            Align(
              alignment: Alignment.bottomCenter,
              child: AspectRatio(
                aspectRatio: 4,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black87,
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              destination.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              destination.location,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white54,
                              ),
                            )
                          ],
                        ),
                      ),
                      RatingBar.builder(
                        initialRating: destination.rate,
                        allowHalfRating: true,
                        unratedColor: Colors.grey,
                        itemSize: 15,
                        ignoreGestures: true,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (value) {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearch() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          IconButton.filledTonal(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: edtSearch,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: 'Search destination here...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: EdgeInsets.all(0),
              ),
              cursorColor: Colors.white,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filledTonal(
            onPressed: () => search(),
            icon: const Icon(
              Icons.search,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
