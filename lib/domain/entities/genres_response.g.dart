// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'genres_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GenresResponse _$$_GenresResponseFromJson(Map<String, dynamic> json) =>
    _$_GenresResponse(
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Genre>[],
    );

Map<String, dynamic> _$$_GenresResponseToJson(_$_GenresResponse instance) =>
    <String, dynamic>{
      'genres': instance.genres,
    };
