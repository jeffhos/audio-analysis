///////////////////////////////////////////////////////////////////////////////
// SingleLevel.pde
//
// Copyright (c) 2012 Jeffrey P. Hoskinson
// All rights reserved.
///////////////////////////////////////////////////////////////////////////////

public class SingleLevel implements Visualization
{
  public SingleLevel()
  {
  }
  
  public void setup( AudioSource source )
  {
    fft = new FFT( source.bufferSize(), source.sampleRate() );
    fft.linAverages(3);
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
    float level = fft.getAvg(0);
    if (level > maxLevel) {
      maxLevel = level;
    } else if ( maxLevel - level > DELAY_RATE ) {
      maxLevel -= DELAY_RATE;
    }
    float factor = ( level / maxLevel );
    color lightColor = color( factor * red( currentColor ),
                              factor * green( currentColor ),
                              factor * blue( currentColor ) );  
    for ( int i = 0; i < NUM_LIGHTS; i++ )
    {
      results[ i ] = lightColor;
    }
    
    return results;
  }
  
  public void teardown()
  {
  }
 
 
  private static final float DELAY_RATE = 0.001;
  
  private FFT fft;
  private float maxLevel = 0.0;
  private int cycle = 0;
}
