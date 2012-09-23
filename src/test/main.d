module main;

import ab.signal;

import std.stdio;
import std.functional;



int main(string[] args) {

	writefln("ab.signal v.%s.%s.%s test application", ABSIGNAL_VERSION_MAJOR, ABSIGNAL_VERSION_MINOR, ABSIGNAL_VERSION_FIX);

	test01();
	test02();
	return 0;
}


void test01() {

	writeln( "Test #01:: Signal & slot: trivial use with classes." );

	class Observable {

		mixin Signal signal;

	}

	class Observer {

		public void slot() {

			writefln( "Observable signaled." );
		}
	}

	auto observable = new Observable;
	auto observer = new Observer;

	observable.signal.connect( &observer.slot );
	observable.signal.emit();
}


void test02() {

	writeln( "Test #02:: Signal with the arguments (and hence slot with parameters).");

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

	auto observable = new Observable;
	auto observer = new Observer;

	observable.numberChanged.connect( &observer.perform );

	observable.setNumber( 8 ); //will print "Observable's number is changed to 8"

	observable.numberChanged.disconnect( &observer.perform );

	observable.setNumber( 0 ); //will print nothing.

}