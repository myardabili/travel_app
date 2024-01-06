import 'package:dartz/dartz.dart';
import 'package:travel_app/core/error/failures.dart';
import 'package:travel_app/features/destination/domain/entities/destination_entity.dart';
import 'package:travel_app/features/destination/domain/repositories/destination_repository.dart';

class GetTopDestinationUseCase {
  final DestinationRepository _repository;

  GetTopDestinationUseCase(this._repository);

  Future<Either<Failure, List<DestinationEntity>>> call() {
    return _repository.top();
  }
}
