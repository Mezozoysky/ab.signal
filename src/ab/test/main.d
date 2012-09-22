module ab.test.main;

import ab.signal;

import std.stdio;
import std.functional;

class Observable {

	private int _number;

	mixin Signal!( int ) numberChanged;

	public void setNumber( int number ) {

		_number = number;
		numberChanged.emit( number );
	}
}

class Observer {

	public void perform( int number ) {

		writefln( "Observable's number is changed to %s", number );
	}
}


enum {
	MAJOR = 0,
	MINOR = 1,
	FIX = 0
}

void printVersion() {

	writefln("ABSig v.%s.%s.%s", MAJOR, MINOR, FIX);
};

mixin Signal versionReq;

 
int main(string[] args) {

	versionReq.connect(toDelegate(&printVersion));
	versionReq.emit();


	auto observable = new Observable;
	auto observer = new Observer;

	observable.numberChanged.connect( &observer.perform );

	observable.setNumber( 8 ); //will print "Observable's number is changed to 8"

	observable.numberChanged.disconnect( &observer.perform );

	observable.setNumber( 0 ); //will print nothing.


	return 0;
}

