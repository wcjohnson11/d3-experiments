// takes a flat array of Sunlight floorUpdates and a flat array of NYT votes
// returns the floorUpdates with .vote properties of the matching NYT vote, if any

var combineFloorUpdatesAndVotes = function ( floorUpdates, votes ) {

  var results = floorUpdates.slice();

  return results.map( function ( item ) {
    var vote = findMatchingVote( item, votes );
    item.vote = vote;
    return item;
  });
};


var findMatchingVote = function ( floorUpdate, votes ) {
  if ( !floorUpdate.roll_ids.length ) {
    return null;
  }
  var matchObj = sunlightRollToNytObj( floorUpdate.roll_ids[0] );
  return findWhere( matchObj, votes );
};

var sunlightRollToNytObj = function ( rollId ) {
  rollId = rollId.split( '-' );
  var year = rollId[1];
  var roll = numbersFromString( rollId[0] );
  var congress = yearToCongress( year )
  var session;
  if ( Number( year ) % 2 === 0 ) {
    session = 2;
  } else {
    session = 1;
  }
  return {
    session: session,
    congress: congress,
    roll_call: roll
  };
};

var numbersFromString = function ( str ) {
  return str.match( /\d/g ).join( '' );
};

var findWhere = function ( obj, arr ) {
  for ( var i = 0; i < arr.length; i++ ) {
    if ( matches( obj, arr[i] ) ) {
      return arr[i];
    }
  }
  return null;
};

// objB is the "bigger" object
var matches = function ( objA, objB ) {
  return Object.keys( objA ).every( function ( key ) {
    return objA[key] == objB[key];
  });
};

var yearToCongress = function ( year ) {
  return Math.floor( 1 + ( year - 1789 ) / 2 );
};

var congressToYear = function ( congress, session ) {
  return ( ( congress - 1 ) * 2 ) + 1789 + ( session - 1 );
};
