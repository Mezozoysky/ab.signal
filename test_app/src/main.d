module main;

import ab.signal;

import std.stdio;
import std.functional;



int main(string[] args) {

	writefln("ab.signal v.%s.%s.%s test application", ABSIGNAL_VERSION_MAJOR, ABSIGNAL_VERSION_MINOR, ABSIGNAL_VERSION_FIX);

	test01();
	test02();
	test03();
	return 0;
}


void test01() {

	writeln( "\nTest #01:: Signal & slot: trivial use with classes.\n" );

	class Observable {

		mixin Signal;

	}

	class Observer {

		public void slot() {

			writefln( "Observable signaled." );
		}
	}

	auto observable = new Observable;
	auto observer = new Observer;

	observable.connect( &observer.slot );
	observable.emit();
}


void test02() {

	writeln( "\nTest #02:: Signal with the arguments (and hence slot with parameters).\n");

	class Observable {

		private int _number;

		mixin Signal occasion;
		mixin Signal!( int ) numberChanged;

		public void setNumber( int number ) {

			_number = number;
			numberChanged.emit( number );
		}
	}

	class Observer {

		public void onOccasion() {

			writeln( "Something happens!");
		}

		public void onNumberChanged( int number ) {

			writefln( "Observable's number is changed to %s", number );
		}
	}

	auto observable = new Observable;
	auto observer = new Observer;

	observable.occasion.connect( &observer.onOccasion );
	observable.numberChanged.connect( &observer.onNumberChanged );

	observable.occasion.emit(); //will print "Something happens!"
	observable.setNumber( 8 ); //will print "Observable's number is changed to 8"

	observable.numberChanged.disconnect( &observer.onNumberChanged );

	observable.occasion.emit(); //will print "Something happens!"
	observable.setNumber( 0 ); //will print nothing.
}

void test03() {

	writeln( "\nTest #03:: Multiple Slots.\n");

	class Officer {

		private string _name;

		public this( string name ) {

			_name = name;
		}

		mixin Signal!( string ) command;

		public void perform( string cmd) {

			writefln( "%s was ordered to: \"%s\"\nPerforming.", _name, cmd);
		}
	}


	auto captain = new Officer( "J. T. Kirk" );
	auto commander = new Officer( "Spock" );
	auto ltCommander = new Officer( "Scott" );
	auto lieutenant = new Officer( "Sulu" );
	auto ensign = new Officer( "Chekov" );

	captain.command.connect( &commander.perform );
	captain.command.connect( &ltCommander.perform );
	captain.command.connect( &lieutenant.perform );
	captain.command.connect( &ensign.perform );

	captain.command.emit( "Attack!! Kill'em all!" );
}