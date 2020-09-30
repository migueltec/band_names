class Band{
    String id;
    String name;
    int votes;

    Band({
        this.id,
        this.name,
        this.votes,
    });

    factory Band.fromMap( Map<String, dynamic> json){
        return Band(
            id: json['id'] ?? 'no-id',
            name: json['name'] ?? 'no-name',
            votes: json['votes'] ??'no-votes'
        );
    }
}