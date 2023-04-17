import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features.dart';
import '../../../core/core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/domain.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Locale myLocale = Localizations.localeOf(context);

    Future.microtask(() {
      ref
          .read(homeNotifierProvider.notifier)
          .getTopMovies(page: 1, language: myLocale.languageCode);
      ref
          .read(homeNotifierProvider.notifier)
          .getNewReleasesMovies(page: 1, language: myLocale.languageCode);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Size sizeScreen = MediaQuery.of(context).size;
    final isSuccess = ref.watch(homeNotifierProvider).topMoviesSuccess;
    final List<Movie>? movies =
        ref.watch(homeNotifierProvider).topMovies?.movies;
    final List<Movie>? newMovies =
        ref.watch(homeNotifierProvider).newReleasesMovies?.movies;
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
              stretch: true,
              pinned: true,
              backgroundColor: ColorsApp.primaryDark,
              expandedHeight: sizeScreen.height * 0.35,
              leading: Image.asset(AssetLocation.movaIcon),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none_outlined,
                        color: Colors.white)),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5), BlendMode.darken),
                    child: Builder(
                      builder: (context) {
                        if (!isSuccess) {
                          return Image.asset(AssetLocation.placeholder,
                              fit: BoxFit.cover);
                        } else {
                          return CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: movies!.first.posterPath?.imgUrl ?? '',
                            placeholder: (context, url) => Image.asset(
                                AssetLocation.placeholder,
                                fit: BoxFit.cover),
                            errorWidget: (context, url, error) => Image.asset(
                                AssetLocation.placeholder,
                                fit: BoxFit.cover),
                          );
                        }
                      },
                    )),
                titlePadding: const EdgeInsets.only(
                  top: 100,
                  left: 20,
                ),
                title: ListView(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    if (!isSuccess)
                      Text(
                        AppLocalizations.of(context)!.loading,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    if (isSuccess)
                      Text(
                        movies!.first.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 5.0),
                    const _MovieGenres(),
                    Row(
                      children: [
                        OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: ColorsApp.primary,
                                minimumSize: const Size(80, 30),
                                maximumSize: const Size(115, 40)),
                            onPressed: (!isSuccess)
                                ? null
                                : () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TrailerVideo(
                                                movieID: movies!.first.id)));
                                  },
                            icon: const Icon(
                              Icons.play_circle,
                              color: Colors.white,
                              size: 14,
                            ),
                            label: Text(AppLocalizations.of(context)!.play,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11))),
                        const SizedBox(width: 10.0),
                        OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              // fixedSize: const Size(80, 10),
                              minimumSize: const Size(80, 30),
                              maximumSize: const Size(100, 40),
                              side: const BorderSide(
                                  width: 2.0, color: Colors.white),
                            ),
                            onPressed: (!isSuccess) ? null : () async {},
                            icon: const Icon(
                              Icons.add,
                              size: 14,
                              color: Colors.white,
                            ),
                            label: FittedBox(
                              child: Text(AppLocalizations.of(context)!.myList,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ))
                      ],
                    ),
                  ],
                ),
              )),
          // if (isSuccess)
          TitleAndMovieList(
              title: AppLocalizations.of(context)!.topMovies,
              movieList: movies),
          TitleAndMovieList(
            title: AppLocalizations.of(context)!.newReleases,
            movieList: newMovies,
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          )
        ],
      ),
    );
  }
}

class TitleAndMovieList extends StatelessWidget {
  const TitleAndMovieList(
      {Key? key,
      required this.title,
      required this.movieList,
      this.height = 290})
      : super(key: key);

  final String title;
  final List<Movie>? movieList;
  final double height;

  void _seeAll(
    BuildContext context,
  ) {
    // Navigator.push(context, route)
    Navigator.pushNamed(context, RoutesApp.seeAllMovies,
        arguments: {'title': title, 'movies': movieList});
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: SizedBox(
            width: double.infinity,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TitleAndSeeAll(
                    title: title,
                    onTap: (movieList == null) ? null : () => _seeAll(context),
                  ),
                ),
                Expanded(
                  child: (movieList == null)
                      ? ListView.builder(
                          itemCount: 3,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 15),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              width: 150,
                              // height: height,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                            );
                          },
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 15),
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) =>
                              BigPosterVertical(
                                movie: movieList![index],
                              )),
                ),
              ],
            )));
  }
}

class _MovieGenres extends ConsumerWidget {
  const _MovieGenres();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstMovie = ref.watch(homeNotifierProvider).firstMovie;
    if (firstMovie == null) {
      return const SizedBox.shrink();
    }

    return FutureBuilder(
      future: ref.read(movieNotifierProvider.notifier).getMovieGenres(
          movieID: firstMovie.id,
          language: Localizations.localeOf(context).languageCode),
      builder: (BuildContext context, AsyncSnapshot<List<Genre>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return SizedBox(
              height: 12,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  String genre = snapshot.data![index].name;
                  String fullGenre = snapshot.data!.length == index + 1
                      ? '$genre.'
                      : '$genre, ';

                  return Text(
                    fullGenre,
                    // softWrap: true,
                    style: const TextStyle(
                        fontSize: 11.0, fontWeight: FontWeight.w400),

                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        } else {
          return Text(
            AppLocalizations.of(context)!.loading,
            style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.w400),
          );
        }
      },
    );
  }
}
