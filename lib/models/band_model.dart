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
            id: json['id'],
            name: json['name'],
            votes: json['votes']
        );
    }
}