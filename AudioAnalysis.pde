///////////////////////////////////////////////////////////////////////////////
// AudioAnalysis.pde
//
// Copyright (c) 2012 Jeffrey P. Hoskinson
// All rights reserved.
///////////////////////////////////////////////////////////////////////////////

import ddf.minim.analysis.*;
import ddf.minim.*;
import processing.net.*;
import processing.serial.*;

// Constants
static final int BAR_WIDTH  =  25;
static final int NUM_LIGHTS =  50;
static final int HALF_LIGHTS = NUM_LIGHTS / 2;
static final int NUM_VISUALIZATION_METHODS = 6;
static final int BAUD_RATE = 57600;
static final int MAX_BRIGHTNESS = 255;
static final int MAX_CYCLE = 1536;

static final float FFT_SCALING_FACTOR = 1.0;

static final color[] LIGHT_COLORS  = new color[ NUM_LIGHTS ];
static final byte[]  SERIAL_BUFFER = new byte[ NUM_LIGHTS * 3 ];

static final boolean ENABLE_SERIAL = true;

static Visualization[] VISUALIZATIONS;

// Global variables
Minim minim;
AudioSource in;
Client myPort;
FFT fft;

int currentVizIndex = 0;
float largestFftValue = 0.0;
float largestLevelValue = 0.0;
int lastUpdate = 0;

void setup()
{
  size( NUM_LIGHTS * BAR_WIDTH, 100 );
  frameRate(30);
  
  minim = new Minim( this );
    
  float colorShift = 512.0 / NUM_LIGHTS;
  for ( int i = 0; i < NUM_LIGHTS; i++ )
  {
    if ( i < NUM_LIGHTS / 2 )
    {
      LIGHT_COLORS[ i ] = color( i * colorShift, 255, 0 );
    }
    else
    {
      int j = i - ( NUM_LIGHTS / 2 );
      LIGHT_COLORS[ i ] = color( 255, 255 - j * colorShift, 0 );
    }
  }
  
  // Set up the serial port
  if ( ENABLE_SERIAL )
  {
    myPort = new Client( this, "192.168.0.7", 2000 );
  }
  
  in = minim.getLineIn( Minim.STEREO, 512 );
  
  VISUALIZATIONS = new Visualization[] {
    new MixLevel(),
    new StereoLevels(),
    new ReverseStereoLevels(),
    new VuMeter(),
    new History(),
    new SingleLevel()
  };
  VISUALIZATIONS[ currentVizIndex ].setup( in );
}


void draw()
{
  background( 0 );
  
  color[] colors = VISUALIZATIONS[ currentVizIndex ].visualize( in );
  
  // Draw the lights
  for ( int i = 0; i < NUM_LIGHTS; i++ )
  {
    float redValue   = red(   colors[ i ] );
    float greenValue = green( colors[ i ] );
    float blueValue  = blue(  colors[ i ] );
      
    fill( redValue, greenValue, blueValue );
    rect( i * BAR_WIDTH, 0, BAR_WIDTH, 100 );
      
    SERIAL_BUFFER[ ( i * 3 )     ] = (byte) redValue;
    SERIAL_BUFFER[ ( i * 3 ) + 1 ] = (byte) greenValue;
    SERIAL_BUFFER[ ( i * 3 ) + 2 ] = (byte) blueValue;
  }
  
  if (ENABLE_SERIAL)
  {
    myPort.write(SERIAL_BUFFER);
  }
}


void keyPressed()
{
  VISUALIZATIONS[ currentVizIndex ].teardown();
  currentVizIndex++;
  if ( currentVizIndex == VISUALIZATIONS.length )
  {
    currentVizIndex = 0;
  }
  VISUALIZATIONS[ currentVizIndex ].setup( in );
}


color[] singleLevel()
{
  color[] results = new color[ NUM_LIGHTS ];  
  int numLightsOn = (int) ( in.mix.level() * (float) NUM_LIGHTS );  
  for ( int i = 0; i < NUM_LIGHTS; i++ )
  {
    results[ i ] = LIGHT_COLORS[ numLightsOn ];
  }
  
  return results;
}



void stop()
{
  if ( ENABLE_SERIAL )
  {
    myPort.write( "000000\n" );
  }
  in.close();
  minim.stop(); 
  super.stop();
}


color wheel( int wheelPos )
{
  if ( wheelPos < 256 ) 
  {
    return color( 255, wheelPos, 0 );
  }
  else if (wheelPos < 512) 
  {
    wheelPos -= 255;
    return color( 255 - wheelPos, 255, 0 );
  }
  else if ( wheelPos < 768 )
  {
    wheelPos -= 512;
    return color( 0, 255, wheelPos );
  }
  else if ( wheelPos < 1024 )
  {
    wheelPos -= 768;
    return color( 0, 255 - wheelPos, 255 );
  }
  else if ( wheelPos < 1280 )
  {
    wheelPos -= 1024;
    return color( wheelPos, 0, 255 );
  }
  else
  {
    wheelPos -= 1280;
    return color( 255, 0, 255 - wheelPos );
  }
}

