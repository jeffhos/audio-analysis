///////////////////////////////////////////////////////////////////////////////
// VuMeter.pde
//
// Copyright (c) 2012 Jeffrey P. Hoskinson
// All rights reserved.
///////////////////////////////////////////////////////////////////////////////

public class VuMeter implements Visualization
{
  public VuMeter()
  {
  }
  
  public void setup( AudioSource source )
  {
    fft = new FFT( source.bufferSize(), source.sampleRate() );
    fft.linAverages( NUM_LIGHTS + 15 );
  }
  
  public color[] visualize( AudioSource in )
  {
    color[] results = new color[ NUM_LIGHTS ];
  
    color currentColor = wheel( cycle++ );
    if ( cycle >= MAX_CYCLE )
    {
      cycle = 0;
    }
  
    fft.forward( in.mix );
    for ( int i = 0; i < NUM_LIGHTS; i++ )
    {
      float fftValue = fft.getAvg( i );
      if ( fftValue > maxValues[ i ] )
      {
        maxValues[ i ] = fftValue;
      }
      else if ( maxValues[ i ] - fftValue > DELAY_RATE )
      {
        maxValues[ i ] -= DELAY_RATE;
      }
      float factor = ( fftValue / maxValues[ i ] );
      if (factor < lastValues[ i ] - DECAY_RATE) {
        factor = lastValues[ i ] - DECAY_RATE;
      }
      results[ i ]  = color( factor * red( currentColor ),
                             factor * green( currentColor ),
                             factor * blue( currentColor ) );
      lastValues[ i ] = factor;
    }
    
    return results;
  }
  
  public void teardown()
  {
    fft = null;
  }
  
  private static final float DELAY_RATE = 0.001;
  private static final float DECAY_RATE = 0.1;
  
  private FFT fft;
  private float[] maxValues = new float[ NUM_LIGHTS ];
  private float[] lastValues = new float[ NUM_LIGHTS ];
  private int cycle = 0;
}
