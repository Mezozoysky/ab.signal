/**
 * Plain and straightforward implementation of the Observer Design Pattern.
 * 
 * Copytight: Copyright &copy; 2012 angryBubo & Stanislav Demyanovich
 * License: <a href="http://www.opensource.org/licenses/MIT">MIT License</a>
 * Authors: Stanislav Demyanovich, <a href="mailto:stan@angrybubo.com">stan@angrybubo.com</a>
 * Date: September 23 2012
 *
 * Example: 
---
import ab.signal;
import std.stdio;

	class Observable {

		mixin Signal signal;
	}

	class Observer {

		public void slot() {

			writeln( "Observable signaled." );
		}
	}

	...

	auto observable = new Observable;
	auto observer = new Observer;

	observable.signal.connect( &observer.slot );

	...

	observable.signal.emit(); //Will print "Observable signaled."

---
 * Exmaple:
---
import ab.signal;
import std.stdio;

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

...

auto observable = new Observable;
auto observer = new Observer;

observable.numberChanged.connect( &observer.perform );

observable.setNumber( 8 ); //will print "Observable's number is changed to 8"

observable.numberChanged.disconnect( &observer.perform );

observable.setNumber( 0 ); //will print nothing.
---
 */
module ab.signal;


public enum {
	/**
	 * <b>ab.signal</b> major version number
	 */
	ABSIGNAL_VERSION_MAJOR = 0,
	/**
	 * <b>ab.signal</b> minor version number
	 */
	ABSIGNAL_VERSION_MINOR = 1,
	/**
	 * <b>ab.signal</b> fix version number
	 */
	ABSIGNAL_VERSION_FIX = 0
}

/**
 * Mixin to create signals and accompanying tools for working with the "slots" (actually, delegates).
 */
mixin template Signal( TT... ) {

	private void delegate( TT ) [] slotList;

	/**
	 * Connects a specified slot to the signal.
	 *
	 * Params:
	 * slot = The slot to connect. It must be a void delegate with parameter list the same as the signal's parameters.
	 */
	public void connect( void delegate( TT ) slot ) {

		foreach ( s; slotList ) {

			if ( slot == s ) return;
		}
		slotList ~= slot;
	}

	/**
	 * Disconnects specified slot from the signal.
	 *
	 * Params:
	 * slot = The slot to disconnect. Nothing happens, if the slot is not connected.
	 */
	public void disconnect( void delegate( TT ) slot ) {

		foreach ( i, s; slotList ) {

			if ( slot == s ) {

				slotList = slotList[0 .. i] ~ slotList[i + 1 .. $];
				return;
			}
		}
	}

	/**
	 * Disconnects all the slots from the signal.
	 */
	public void disconnectAll() {

		foreach ( s; slotList ) {

			s = null;
		}

		slotList.length = 0;
	}

	/**
	 * Emits the signal, i.e. calls all the slots which has connected the the signal emitted with the cpecified argument list.
	 *
	 * Params:
	 * tt = Actual argument list. It must correspond the signal's parameter list.
	 */
	public void emit( TT tt ) {

		foreach( slot; slotList ) {

			slot( tt );
		}
	}
}


/*
	Unittests
*/

unittest {

	import std.stdio;

	class Observable {

		private int _number;

		mixin Signal!( int ) numberChanged;

		public void setNumber( int number ) {

			_number = number;
			numberChanged.emit( number );
		}
	}

	class Observer {

		private int _number;

		@property int number() { return _number; }
		
		public void perform( int number ) {
		
			_number = number;
		}
	}


	auto observable = new Observable;
	auto observer = new Observer;

	observable.numberChanged.connect( &observer.perform );
	observable.setNumber( 8 );

	assert( observer.number == 8 );

	observable.numberChanged.disconnect( &observer.perform );

	observable.setNumber( 0 );

	assert( observer.number == 8 );
}