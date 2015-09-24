

##Operators

###|+|

(from http://yaxu.org/demonstrating-tidal/)

The |+| operator knits together different synth parameters into a whole synth trigger message, which is then sent to the synth over the network (the actual sound is not rendered with Haskell here).

This video demonstrates the |+| combinator a little more, blending parameters to pan the sounds using a sine function, do a spot of waveshaping, and to apply a vowel formant filter:

##Functions

To change patterns, either sequences or continuous ones, you can select from a variety of functions to apply.

Because Tidal patterns are defined as something called an &quot;applicative
functor&quot;, it&#39;s easy to combine them. For example, if you have two
patterns of numbers, you can combine the patterns by, for example,
multiplying the numbers inside them together, like this:

<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="p">(</span><span class="n">brak</span> <span class="p">(</span><span class="n">sound</span> <span class="s">&quot;bd sn:2 bd sn&quot;</span><span class="p">))</span>
   <span class="o">|+|</span> <span class="n">pan</span> <span class="p">((</span><span class="o">*</span><span class="p">)</span> <span class="o">&lt;$&gt;</span> <span class="n">sinewave1</span> <span class="o">&lt;*&gt;</span> <span class="p">(</span><span class="n">slow</span> <span class="mi">8</span> <span class="o">$</span> <span class="s">&quot;0 0.25 0.75&quot;</span><span class="p">))</span>
</code></pre></div>

In the above, the <code>sinewave1</code> and the <code>(slow 8 $ &quot;0 0.25 0.75&quot;)</code>
pattern are multiplied together. Using the <code>&lt;$&gt;</code> and the <code>&lt;*&gt;</code> in this way turns the <code>*</code> operator, which normally works with two numbers, into a
function that instead works on two <em>patterns</em> of numbers.</p>

<p>Here&#39;s another example of this technique:</p>

<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">sound</span> <span class="p">(</span><span class="n">pick</span> <span class="o">&lt;$&gt;</span> <span class="s">&quot;kurt mouth can*3 sn&quot;</span> <span class="o">&lt;*&gt;</span> <span class="n">slow</span> <span class="mi">7</span> <span class="s">&quot;0 1 2 3 4&quot;</span><span class="p">)</span>
</code></pre></div>

The <code>pick</code> function normally just takes the name of a set of samples
(such as <code>kurt</code>), and a number, and returns a sample with that
number. Again, using <code>&lt;$&gt;</code> and <code>&lt;*&gt;</code> turns <code>pick</code> into a function that
operates on patterns, rather than simple values. In practice, this
means you can pattern sample numbers separately from sample
sets. Because the sample numbers have been slowed down in the above,
an interesting texture results.</p>

<p>By the way, &quot;0 1 2 3 4&quot; in the above could be replaced with the
pattern generator <code>run 5</code>.</p>

<p>In the following sections contain functions for various applications, some will transform the pattern itself (make slower, faster), change the samples within the pattern (chop them in to tiny bits) and others will combine two patterns into a new one.</p>
   
                <section>
                    <header>
                        <h1 id="pattern_transformers" class="tidal-toc-heading">Pattern Transformers</h1>
                    </header>

                     
                    
                    <article>
                         <p>Pattern transformers are functions that take a pattern as input and transform
it into a new pattern.</p>

<p>In the following, functions are shown with their Haskell type and a
short description of how they work.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="beat-rotation" class="tidal-toc-heading">Beat rotation</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="p">(</span><span class="o">&lt;~</span><span class="p">)</span> <span class="ow">::</span> <span class="kt">Time</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p>or</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="p">(</span><span class="o">~&gt;</span><span class="p">)</span> <span class="ow">::</span> <span class="kt">Time</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p>(The above means that <code>&lt;~</code> and <code>~&gt;</code> are functions that are given a
time value and a pattern of any type, and returns a pattern of the
same type.)</p>

<p>Rotate a loop either to the left or the right.</p>

<p>Example:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">every</span> <span class="mi">4</span> <span class="p">(</span><span class="mf">0.25</span> <span class="o">&lt;~</span><span class="p">)</span> <span class="o">$</span> <span class="n">sound</span> <span class="p">(</span><span class="n">density</span> <span class="mi">2</span> <span class="s">&quot;bd sn kurt&quot;</span><span class="p">)</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="mapping-over-patterns" class="tidal-toc-heading">Mapping over patterns</h1>
                         <p>Sometimes you want to transform all the events inside a pattern, and
not the time structure of the pattern itself. For example, if you
wanted to pass a sinewave to <code>shape</code>, but wanted the sinewave to go
from <code>0</code> to <code>0.5</code> rather than from <code>0</code> to <code>1</code>, you could do this:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bd*2 [bd [sn sn*2 sn] sn]&quot;</span>
   <span class="o">|+|</span> <span class="n">shape</span> <span class="p">((</span><span class="o">/</span> <span class="mi">2</span><span class="p">)</span> <span class="o">&lt;$&gt;</span> <span class="n">sinewave1</span><span class="p">)</span>
</code></pre></div>
<p>The above applies the function <code>(/ 2)</code> (which simply means divide by
two), to all the values inside the <code>sinewave1</code> pattern.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="brak" class="tidal-toc-heading">brak</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">brak</span> <span class="ow">::</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p>(The above means that <code>brak</code> is a function from patterns of any type,
to a pattern of the same type.)</p>

<p>Make a pattern sound a bit like a breakbeat</p>

<p>Example:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">sound</span> <span class="p">(</span><span class="n">brak</span> <span class="s">&quot;bd sn kurt&quot;</span><span class="p">)</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="degrade" class="tidal-toc-heading">degrade</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">degrade</span> <span class="ow">::</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
<span class="nf">degradeBy</span> <span class="ow">::</span> <span class="kt">Double</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p><code>degrade</code> randomly removes events from a pattern 50% of the time:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">slow</span> <span class="mi">2</span> <span class="o">$</span> <span class="n">degrade</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;[[[feel:5*8,feel*3] feel:3*8], feel*4]&quot;</span>
   <span class="o">|+|</span> <span class="n">accelerate</span> <span class="s">&quot;-6&quot;</span>
   <span class="o">|+|</span> <span class="n">speed</span> <span class="s">&quot;2&quot;</span>
</code></pre></div>
<p>The shorthand syntax for <code>degrade</code> is a question mark: <code>?</code>. Using <code>?</code>
will allow you to randomly remove events from a portion of a pattern:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">slow</span> <span class="mi">2</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bd ~ sn bd ~ bd? [sn bd?] ~&quot;</span>
</code></pre></div>
<p>You can also use <code>?</code> to randomly remove events from entire sub-patterns:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">slow</span> <span class="mi">2</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;[[[feel:5*8,feel*3] feel:3*8]?, feel*4]&quot;</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="degrade-by" class="tidal-toc-heading">degrade_by</h1>
                         <p><code>degradeBy</code> allows you to control the percentage of events that
are removed. For example, to remove events 90% of the time:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">slow</span> <span class="mi">2</span> <span class="o">$</span> <span class="n">degradeBy</span> <span class="mf">0.9</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;[[[feel:5*8,feel*3] feel:3*8], feel*4]&quot;</span>
   <span class="o">|+|</span> <span class="n">accelerate</span> <span class="s">&quot;-6&quot;</span>
   <span class="o">|+|</span> <span class="n">speed</span> <span class="s">&quot;2&quot;</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="density" class="tidal-toc-heading">density</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">density</span> <span class="ow">::</span> <span class="kt">Time</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p>Speed up a pattern.</p>

<p>Example:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">sound</span> <span class="p">(</span><span class="n">density</span> <span class="mi">2</span> <span class="s">&quot;bd sn kurt&quot;</span><span class="p">)</span>
   <span class="o">|+|</span> <span class="n">density</span> <span class="mi">3</span> <span class="p">(</span><span class="n">vowel</span> <span class="s">&quot;a e o&quot;</span><span class="p">)</span>
</code></pre></div>
<p>Also, see <code>slow</code>.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="iter" class="tidal-toc-heading">iter</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">iter</span> <span class="ow">::</span> <span class="kt">Int</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p>Divides a pattern into a given number of subdivisions, plays the subdivisions
in order, but increments the starting subdivision each cycle. The pattern
wraps to the first subdivision after the last subdivision is played.</p>

<p>Example:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">iter</span> <span class="mi">4</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bd hh sn cp&quot;</span>
</code></pre></div>
<p>This will produce the following over four cycles:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">bd</span> <span class="n">hh</span> <span class="n">sn</span> <span class="n">cp</span>
<span class="nf">hh</span> <span class="n">sn</span> <span class="n">cp</span> <span class="n">bd</span>
<span class="nf">sn</span> <span class="n">cp</span> <span class="n">bd</span> <span class="n">hh</span>
<span class="nf">cp</span> <span class="n">bd</span> <span class="n">hh</span> <span class="n">sn</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="jux" class="tidal-toc-heading">jux</h1>
                         <p>The <code>jux</code> function creates strange stereo effects, by applying a
function to a pattern, but only in the right-hand channel. For
example, the following reverses the pattern on the righthand side:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">slow</span> <span class="mi">32</span> <span class="o">$</span> <span class="n">jux</span> <span class="p">(</span><span class="n">rev</span><span class="p">)</span> <span class="o">$</span> <span class="n">striate&#39;</span> <span class="mi">32</span> <span class="p">(</span><span class="mi">1</span><span class="o">/</span><span class="mi">16</span><span class="p">)</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bev&quot;</span>
</code></pre></div>
<p>When passing pattern transforms to functions like <code>jux</code> and <code>every</code>,
it&#39;s possible to chain multiple transforms together with <code>.</code>, for
example this both reverses and halves the playback speed of the
pattern in the righthand channel:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">slow</span> <span class="mi">32</span> <span class="o">$</span> <span class="n">jux</span> <span class="p">((</span><span class="o">|+|</span> <span class="n">speed</span> <span class="s">&quot;0.5&quot;</span><span class="p">)</span> <span class="o">.</span> <span class="n">rev</span><span class="p">)</span> <span class="o">$</span> <span class="n">striate&#39;</span> <span class="mi">32</span> <span class="p">(</span><span class="mi">1</span><span class="o">/</span><span class="mi">16</span><span class="p">)</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bev&quot;</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="palindrome" class="tidal-toc-heading">palindrome</h1>
                         <p><code>palindrome</code> applies <code>rev</code> to  a pattern every other cycle, so that
the pattern alternates between forwards and backwards. </p>

<p>Example:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">palindrome</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;hh*2 [sn cp] cp future*4&quot;</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="rev" class="tidal-toc-heading">rev</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">rev</span> <span class="ow">::</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p>Reverse a pattern</p>

<p>Examples:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">every</span> <span class="mi">3</span> <span class="p">(</span><span class="n">rev</span><span class="p">)</span> <span class="o">$</span> <span class="n">sound</span> <span class="p">(</span><span class="n">density</span> <span class="mi">2</span> <span class="s">&quot;bd sn kurt&quot;</span><span class="p">)</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="slow" class="tidal-toc-heading">slow</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">slow</span> <span class="ow">::</span> <span class="kt">Time</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p>Slow down a pattern.</p>

<p>Example:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">sound</span> <span class="p">(</span><span class="n">slow</span> <span class="mi">2</span> <span class="s">&quot;bd sn kurt&quot;</span><span class="p">)</span>
   <span class="o">|+|</span> <span class="n">slow</span> <span class="mi">3</span> <span class="p">(</span><span class="n">vowel</span> <span class="s">&quot;a e o&quot;</span><span class="p">)</span>
</code></pre></div>
<p>Slow also accepts numbers between 0 and 1, which causes the pattern to speed up:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">sound</span> <span class="p">(</span><span class="n">slow</span> <span class="mf">0.5</span> <span class="s">&quot;bd sn kurt&quot;</span><span class="p">)</span>
   <span class="o">|+|</span> <span class="n">slow</span> <span class="mf">0.75</span> <span class="p">(</span><span class="n">vowel</span> <span class="s">&quot;a e o&quot;</span><span class="p">)</span>
</code></pre></div>
<p>Also, see <code>density</code>.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="slowspread" class="tidal-toc-heading">slowspread</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">slowspread</span> <span class="ow">::</span> <span class="p">(</span><span class="n">a</span> <span class="ow">-&gt;</span> <span class="n">t</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">b</span><span class="p">)</span> <span class="ow">-&gt;</span> <span class="p">[</span><span class="n">a</span><span class="p">]</span> <span class="ow">-&gt;</span> <span class="n">t</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">b</span>
</code></pre></div>
<p><code>slowspread</code> takes a list of pattern transforms and applies them one at a time, per cycle, 
then repeats.</p>

<p>Example:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">slowspread</span> <span class="p">(</span><span class="o">$</span><span class="p">)</span> <span class="p">[</span><span class="n">density</span> <span class="mi">2</span><span class="p">,</span> <span class="n">rev</span><span class="p">,</span> <span class="n">slow</span> <span class="mi">2</span><span class="p">,</span> <span class="n">striate</span> <span class="mi">3</span><span class="p">,</span> <span class="p">(</span><span class="o">|+|</span> <span class="n">speed</span> <span class="s">&quot;0.8&quot;</span><span class="p">)]</span> 
    <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;[bd*2 [~ bd]] [sn future]*2 cp jvbass*4&quot;</span>
</code></pre></div>
<p>Above, the pattern will have these transforms applied to it, one at a time, per cycle:</p>

<ul>
<li>cycle 1: <code>density 2</code> - pattern will increase in speed</li>
<li>cycle 2: <code>rev</code> - pattern will be reversed</li>
<li>cycle 3: <code>slow 2</code> - pattern will decrease in speed</li>
<li>cycle 4: <code>striate 3</code> - pattern will be granualized</li>
<li>cycle 5: <code>(|+| speed &quot;0.8&quot;)</code> - pattern samples will be played back more slowly</li>
</ul>

<p>After <code>(|+| speed &quot;0.8&quot;)</code>, the transforms will repeat and start at <code>density 2</code> again.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="smash" class="tidal-toc-heading">smash</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">smash</span> <span class="ow">::</span> <span class="kt">Int</span> <span class="ow">-&gt;</span> <span class="p">[</span><span class="kt">Time</span><span class="p">]</span> <span class="ow">-&gt;</span> <span class="kt">OscPattern</span> <span class="ow">-&gt;</span> <span class="kt">OscPattern</span>
</code></pre></div>
<p>Smash is a combination of <code>spread</code> and <code>striate</code> - it cuts the samples
into the given number of bits, and then cuts between playing the loop
at different speeds according to the values in the list.</p>

<p>So this:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell">  <span class="n">d1</span> <span class="o">$</span> <span class="n">smash</span> <span class="mi">3</span> <span class="p">[</span><span class="mi">2</span><span class="p">,</span><span class="mi">3</span><span class="p">,</span><span class="mi">4</span><span class="p">]</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;ho ho:2 ho:3 hc&quot;</span>
</code></pre></div>
<p>Is a bit like this:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell">  <span class="n">d1</span> <span class="o">$</span> <span class="n">spread</span> <span class="p">(</span><span class="n">slow</span><span class="p">)</span> <span class="p">[</span><span class="mi">2</span><span class="p">,</span><span class="mi">3</span><span class="p">,</span><span class="mi">4</span><span class="p">]</span> <span class="o">$</span> <span class="n">striate</span> <span class="mi">3</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;ho ho:2 ho:3 hc&quot;</span>
</code></pre></div>
<p>This is quite dancehall:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="p">(</span><span class="n">spread&#39;</span> <span class="n">slow</span> <span class="s">&quot;1%4 2 1 3&quot;</span> <span class="o">$</span> <span class="n">spread</span> <span class="p">(</span><span class="n">striate</span><span class="p">)</span> <span class="p">[</span><span class="mi">2</span><span class="p">,</span><span class="mi">3</span><span class="p">,</span><span class="mi">4</span><span class="p">,</span><span class="mi">1</span><span class="p">]</span> <span class="o">$</span> <span class="n">sound</span>
<span class="s">&quot;sn:2 sid:3 cp sid:4&quot;</span><span class="p">)</span>
  <span class="o">|+|</span> <span class="n">speed</span> <span class="s">&quot;[1 2 1 1]/2&quot;</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="spread" class="tidal-toc-heading">spread</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">spread</span> <span class="ow">::</span> <span class="p">(</span><span class="n">a</span> <span class="ow">-&gt;</span> <span class="n">t</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">b</span><span class="p">)</span> <span class="ow">-&gt;</span> <span class="p">[</span><span class="n">a</span><span class="p">]</span> <span class="ow">-&gt;</span> <span class="n">t</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">b</span>
</code></pre></div>
<p>(The above is difficult to describe, if you don&#39;t understand Haskell,
just read the description and examples..)</p>

<p>The <code>spread</code> function allows you to take a pattern transformation
which takes a parameter, such as <code>slow</code>, and provide several
parameters which are switched between. In other words it &#39;spreads&#39; a
function across several values.</p>

<p>Taking a simple high hat loop as an example:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;ho ho:2 ho:3 hc&quot;</span>
</code></pre></div>
<p>We can slow it down by different amounts, such as by a half:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell">  <span class="n">d1</span> <span class="o">$</span> <span class="n">slow</span> <span class="mi">2</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;ho ho:2 ho:3 hc&quot;</span>
</code></pre></div>
<p>Or by four thirds (i.e. speeding it up by a third; <code>4%3</code> means four over
three):</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell">  <span class="n">d1</span> <span class="o">$</span> <span class="n">slow</span> <span class="p">(</span><span class="mi">4</span><span class="o">%</span><span class="mi">3</span><span class="p">)</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;ho ho:2 ho:3 hc&quot;</span>
</code></pre></div>
<p>But if we use <code>spread</code>, we can make a pattern which alternates between
the two speeds:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">spread</span> <span class="n">slow</span> <span class="p">[</span><span class="mi">2</span><span class="p">,</span><span class="mi">4</span><span class="o">%</span><span class="mi">3</span><span class="p">]</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;ho ho:2 ho:3 hc&quot;</span>
</code></pre></div>
<p>There&#39;s a version of this function, <code>spread&#39;</code> (pronounced &quot;spread prime&quot;), which takes a <em>pattern</em> of parameters, instead of a list:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">spread&#39;</span> <span class="n">slow</span> <span class="s">&quot;2 4%3&quot;</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;ho ho:2 ho:3 hc&quot;</span>
</code></pre></div>
<p>This is quite a messy area of Tidal - due to a slight difference of
implementation this sounds completely different! One advantage of
using <code>spread&#39;</code> though is that you can provide polyphonic parameters, e.g.:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">spread&#39;</span> <span class="n">slow</span> <span class="s">&quot;[2 4%3, 3]&quot;</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;ho ho:2 ho:3 hc&quot;</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="trunc" class="tidal-toc-heading">trunc</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">trunc</span> <span class="ow">::</span> <span class="kt">Time</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p>Truncates a pattern so that only a fraction of the pattern is played. 
The following example plays only the first three quarters of the pattern:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">trunc</span> <span class="mf">0.75</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bd sn*2 cp hh*4 arpy bd*2 cp bd*2&quot;</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="zoom" class="tidal-toc-heading">zoom</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">zoom</span> <span class="ow">::</span> <span class="kt">Arc</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p>Plays a portion of a pattern, specified by a beginning and end arc of time. 
The new resulting pattern is played over the time period of the original pattern:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">zoom</span> <span class="p">(</span><span class="mf">0.25</span><span class="p">,</span> <span class="mf">0.75</span><span class="p">)</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bd*2 hh*3 [sn bd]*2 drum&quot;</span>
</code></pre></div>
<p>In the pattern above, <code>zoom</code> is used with an arc from 25% to 75%. It is equivalent to this pattern:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;hh*3 [sn bd]*2&quot;</span>
</code></pre></div>
                    </article>
                    
                    
                </section>
                  
                <section>
                    <header>
                        <h1 id="sample" class="tidal-toc-heading">Sample Transformers</h1>
                    </header>

                     
                    
                    <article>
                         <p>The following functions manipulate each sample within a pattern, some granularize them, others echo.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="chop" class="tidal-toc-heading">chop</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">chop</span> <span class="ow">::</span> <span class="kt">Int</span> <span class="ow">-&gt;</span> <span class="kt">OscPattern</span> <span class="ow">-&gt;</span> <span class="kt">OscPattern</span>
</code></pre></div>
<p><code>chop</code> granualizes every sample in place as it is played, turning a pattern of samples into a pattern of sample parts. Use an integer value to specify how many granules each sample is chopped into:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">chop</span> <span class="mi">16</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;arpy arp feel*4 arpy*4&quot;</span>
</code></pre></div>
<p>Different values of <code>chop</code> can yield very different results, depending
on the samples used:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">chop</span> <span class="mi">16</span> <span class="o">$</span> <span class="n">sound</span> <span class="p">(</span><span class="n">samples</span> <span class="s">&quot;arpy*8&quot;</span> <span class="p">(</span><span class="n">run</span> <span class="mi">16</span><span class="p">))</span>
<span class="nf">d1</span> <span class="o">$</span> <span class="n">chop</span> <span class="mi">32</span> <span class="o">$</span> <span class="n">sound</span> <span class="p">(</span><span class="n">samples</span> <span class="s">&quot;arpy*8&quot;</span> <span class="p">(</span><span class="n">run</span> <span class="mi">16</span><span class="p">))</span>
<span class="nf">d1</span> <span class="o">$</span> <span class="n">chop</span> <span class="mi">256</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bd*4 [sn cp] [hh future]*2 [cp feel]&quot;</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="gap" class="tidal-toc-heading">gap</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">gap</span> <span class="ow">::</span> <span class="kt">Int</span> <span class="ow">-&gt;</span> <span class="kt">OscPattern</span> <span class="ow">-&gt;</span> <span class="kt">OscPattern</span>
</code></pre></div>
<p><code>gap</code> is similar to <code>chop</code> in that it granualizes every sample in place as it is played, 
but every other grain is silent. Use an integer value to specify how many granules 
each sample is chopped into:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">gap</span> <span class="mi">8</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;jvbass&quot;</span>
<span class="nf">d1</span> <span class="o">$</span> <span class="n">gap</span> <span class="mi">16</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;[jvbass drum:4]&quot;</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="striate" class="tidal-toc-heading">striate</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">striate</span> <span class="ow">::</span> <span class="kt">Int</span> <span class="ow">-&gt;</span> <span class="kt">OscPattern</span> <span class="ow">-&gt;</span> <span class="kt">OscPattern</span>
</code></pre></div>
<p>Striate is a kind of granulator, for example:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">striate</span> <span class="mi">3</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;ho ho:2 ho:3 hc&quot;</span>
</code></pre></div>
<p>This plays the loop the given number of times, but triggering
progressive portions of each sample. So in this case it plays the loop
three times, the first time playing the first third of each sample,
then the second time playing the second third of each sample, etc..
With the highhat samples in the above example it sounds a bit like
reverb, but it isn&#39;t really.</p>

<p>You can also use striate with very long samples, to cut it into short
chunks and pattern those chunks. This is where things get towards
granular synthesis. The following cuts a sample into 128 parts, plays
it over 8 cycles and manipulates those parts by reversing and rotating
the loops.</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span>  <span class="n">slow</span> <span class="mi">8</span> <span class="o">$</span> <span class="n">striate</span> <span class="mi">128</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bev&quot;</span>
</code></pre></div>
<p>The <code>striate&#39;</code> function is a variant of <code>striate</code> with an extra
parameter, which specifies the length of each part. The <code>striate&#39;</code>
function still scans across the sample over a single cycle, but if
each bit is longer, it creates a sort of stuttering effect. For
example the following will cut the bev sample into 32 parts, but each
will be 1/16th of a sample long:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">slow</span> <span class="mi">32</span> <span class="o">$</span> <span class="n">striate&#39;</span> <span class="mi">32</span> <span class="p">(</span><span class="mi">1</span><span class="o">/</span><span class="mi">16</span><span class="p">)</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bev&quot;</span>
</code></pre></div>
<p>Note that <code>striate</code> uses the <code>begin</code> and <code>end</code> parameters
internally. This means that if you&#39;re using <code>striate</code> (or <code>striate&#39;</code>)
you probably shouldn&#39;t also specify <code>begin</code> or <code>end</code>.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="stut" class="tidal-toc-heading">stut</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">stut</span> <span class="ow">::</span> <span class="kt">Integer</span> <span class="ow">-&gt;</span> <span class="kt">Double</span> <span class="ow">-&gt;</span> <span class="kt">Rational</span> <span class="ow">-&gt;</span> <span class="kt">OscPattern</span> <span class="ow">-&gt;</span> <span class="kt">OscPattern</span>
</code></pre></div>
<p>Stut applies a type of delay to a pattern. It has three parameters, 
which could be called depth, feedback and time. Depth is an integer
and the others floating point. This adds a bit of echo:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">stut</span> <span class="mi">4</span> <span class="mf">0.5</span> <span class="mf">0.2</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bd sn&quot;</span>
</code></pre></div>
<p>The above results in 4 echos, each one 50% quieter than the last, 
with 1/5th of a cycle between them. It is possible to reverse the echo:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">stut</span> <span class="mi">4</span> <span class="mf">0.5</span> <span class="p">(</span><span class="o">-</span><span class="mf">0.2</span><span class="p">)</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bd sn&quot;</span>
</code></pre></div>
                    </article>
                    
                    
                </section>
                  
                <section>
                    <header>
                        <h1 id="conditional" class="tidal-toc-heading">Conditional Transformers</h1>
                    </header>

                     
                    
                    <article>
                         <p>Conditional transformers are functions that apply other transformations under certain cirumstances. These can be based upon the number of cycles, probability or time-range within a pattern.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="every" class="tidal-toc-heading">every</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">every</span> <span class="ow">::</span> <span class="kt">Int</span> <span class="ow">-&gt;</span> <span class="p">(</span><span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span><span class="p">)</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p><code>every</code> transforms a pattern with a function, but only for the given number of repetitions.</p>

<p>Example:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">every</span> <span class="mi">3</span> <span class="p">(</span><span class="n">density</span> <span class="mi">2</span><span class="p">)</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bd sn kurt&quot;</span>
</code></pre></div>
<p>Also, see <code>whenmod</code>.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="foldevery" class="tidal-toc-heading">foldEvery</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">foldEvery</span> <span class="ow">::</span> <span class="p">[</span><span class="kt">Int</span><span class="p">]</span> <span class="ow">-&gt;</span> <span class="p">(</span><span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span><span class="p">)</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p><code>foldEvery</code> transforms a pattern with a function, but only for the given number of repetitions. 
It is similar to chaining multiple <code>every</code> functions together.</p>

<p>Example:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">foldEvery</span> <span class="p">[</span><span class="mi">3</span><span class="p">,</span> <span class="mi">4</span><span class="p">,</span> <span class="mi">5</span><span class="p">]</span> <span class="p">(</span><span class="n">density</span> <span class="mi">2</span><span class="p">)</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bd sn kurt&quot;</span>

<span class="c1">-- this is equal to:</span>
<span class="nf">d1</span> <span class="o">$</span> <span class="n">every</span> <span class="mi">3</span> <span class="p">(</span><span class="n">density</span> <span class="mi">2</span><span class="p">)</span> <span class="o">$</span> <span class="n">every</span> <span class="mi">4</span> <span class="p">(</span><span class="n">density</span> <span class="mi">2</span><span class="p">)</span> <span class="o">$</span> <span class="n">every</span> <span class="mi">5</span> <span class="p">(</span><span class="n">density</span> <span class="mi">2</span><span class="p">)</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bd sn kurt&quot;</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="sometimesby" class="tidal-toc-heading">sometimesBy</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">sometimesBy</span> <span class="ow">::</span> <span class="kt">Double</span> <span class="ow">-&gt;</span> <span class="p">(</span><span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span><span class="p">)</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p>Use <code>sometimesBy</code> to apply a given function &quot;sometimes&quot;. For example, the 
following code results in <code>density 2</code> being applied about 25% of the time:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">sometimesBy</span> <span class="mf">0.25</span> <span class="p">(</span><span class="n">density</span> <span class="mi">2</span><span class="p">)</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bd*8&quot;</span>
</code></pre></div>
<p>There are some aliases as well:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">sometimes</span> <span class="ow">=</span> <span class="n">sometimesBy</span> <span class="mf">0.5</span>
<span class="nf">often</span> <span class="ow">=</span> <span class="n">sometimesBy</span> <span class="mf">0.75</span>
<span class="nf">rarely</span> <span class="ow">=</span> <span class="n">sometimesBy</span> <span class="mf">0.25</span>
<span class="nf">almostNever</span> <span class="ow">=</span> <span class="n">sometimesBy</span> <span class="mf">0.1</span>
<span class="nf">almostAlways</span> <span class="ow">=</span> <span class="n">sometimesBy</span> <span class="mf">0.9</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="whenmod" class="tidal-toc-heading">whenmod</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">whenmod</span> <span class="ow">::</span> <span class="kt">Int</span> <span class="ow">-&gt;</span> <span class="kt">Int</span> <span class="ow">-&gt;</span> <span class="p">(</span><span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span><span class="p">)</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p><code>whenmod</code> has a similar form and behavior to <code>every</code>, but requires an 
additional number. Applies the function to the pattern, when the
remainder of the current loop number divided by the first parameter,
is less than the second parameter.</p>

<p>For example the following makes every other block of four loops twice
as dense:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">whenmod</span> <span class="mi">8</span> <span class="mi">4</span> <span class="p">(</span><span class="n">density</span> <span class="mi">2</span><span class="p">)</span> <span class="p">(</span><span class="n">sound</span> <span class="s">&quot;bd sn kurt&quot;</span><span class="p">)</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="within" class="tidal-toc-heading">within</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">within</span> <span class="ow">::</span> <span class="kt">Arc</span> <span class="ow">-&gt;</span> <span class="p">(</span><span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span><span class="p">)</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p>Use <code>within</code> to apply a function to only a part of a pattern. For example, to
apply <code>density 2</code> to only the first half of a pattern:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">within</span> <span class="p">(</span><span class="mi">0</span><span class="p">,</span> <span class="mf">0.5</span><span class="p">)</span> <span class="p">(</span><span class="n">density</span> <span class="mi">2</span><span class="p">)</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bd*2 sn lt mt hh hh hh hh&quot;</span>
</code></pre></div>
<p>Or, to apply `(|+| speed &quot;0.5&quot;) to only the last quarter of a pattern:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">within</span> <span class="p">(</span><span class="mf">0.75</span><span class="p">,</span> <span class="mi">1</span><span class="p">)</span> <span class="p">(</span><span class="o">|+|</span> <span class="n">speed</span> <span class="s">&quot;0.5&quot;</span><span class="p">)</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bd*2 sn lt mt hh hh hh hh&quot;</span>
</code></pre></div>
                    </article>
                    
                    
                </section>
                  
                <section>
                    <header>
                        <h1 id="compositions" class="tidal-toc-heading">Compositions</h1>
                    </header>

                     
                    
                    <article>
                         <p>Some functions work with multiple sets of patterns, interlace them or play them successively.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="append" class="tidal-toc-heading">append</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">append</span> <span class="ow">::</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
<span class="nf">append&#39;</span> <span class="ow">::</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p><code>append</code> combines two patterns into a new pattern, so
that the events of the second pattern are appended to those of the
first pattern, within a single cycle.</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">append</span> <span class="p">(</span><span class="n">sound</span> <span class="s">&quot;bd*2 sn&quot;</span><span class="p">)</span> <span class="p">(</span><span class="n">sound</span> <span class="s">&quot;arpy jvbass*2&quot;</span><span class="p">)</span>
</code></pre></div>
<p><code>append&#39;</code> does the same as <code>append</code>, but over two cycles, so that
the cycles alternate between the two patterns.</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">append&#39;</span> <span class="p">(</span><span class="n">sound</span> <span class="s">&quot;bd*2 sn&quot;</span><span class="p">)</span> <span class="p">(</span><span class="n">sound</span> <span class="s">&quot;arpy jvbass*2&quot;</span><span class="p">)</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="cat" class="tidal-toc-heading">cat</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">cat</span> <span class="ow">::</span> <span class="p">[</span><span class="kt">Pattern</span> <span class="n">a</span><span class="p">]</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p><code>cat</code> concatenates a list of patterns into a new pattern. The new pattern&#39;s length will 
be a single cycle. Note that the more patterns you add to the list, the faster each pattern
will be played so that all patterns can fit into a single cycle. Examples:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">cat</span> <span class="p">[</span><span class="n">sound</span> <span class="s">&quot;bd*2 sn&quot;</span><span class="p">,</span> <span class="n">sound</span> <span class="s">&quot;arpy jvbass*2&quot;</span><span class="p">]</span>
<span class="nf">d1</span> <span class="o">$</span> <span class="n">cat</span> <span class="p">[</span><span class="n">sound</span> <span class="s">&quot;bd*2 sn&quot;</span><span class="p">,</span> <span class="n">sound</span> <span class="s">&quot;arpy jvbass*2&quot;</span><span class="p">,</span> <span class="n">sound</span> <span class="s">&quot;drum*2&quot;</span><span class="p">]</span>
<span class="nf">d1</span> <span class="o">$</span> <span class="n">cat</span> <span class="p">[</span><span class="n">sound</span> <span class="s">&quot;bd*2 sn&quot;</span><span class="p">,</span> <span class="n">sound</span> <span class="s">&quot;jvbass*3&quot;</span><span class="p">,</span> <span class="n">sound</span> <span class="s">&quot;drum*2&quot;</span><span class="p">,</span> <span class="n">sound</span> <span class="s">&quot;ht mt&quot;</span><span class="p">]</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="interlace" class="tidal-toc-heading">interlace</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">interlace</span> <span class="ow">::</span> <span class="kt">OscPattern</span> <span class="ow">-&gt;</span> <span class="kt">OscPattern</span> <span class="ow">-&gt;</span> <span class="kt">OscPattern</span>
</code></pre></div>
<p>(A function that takes two OscPatterns, and blends them together into
a new OscPattern. An OscPattern is basically a pattern of messages to
a synthesiser.)</p>

<p>Shifts between the two given patterns, using distortion.</p>

<p>Example:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">interlace</span> <span class="p">(</span><span class="n">sound</span>  <span class="s">&quot;bd sn kurt&quot;</span><span class="p">)</span> <span class="p">(</span><span class="n">every</span> <span class="mi">3</span> <span class="n">rev</span> <span class="o">$</span> <span class="n">sound</span>  <span class="s">&quot;bd sn:2&quot;</span><span class="p">)</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="seqp" class="tidal-toc-heading">seqP</h1>
                         <p>There is a similar function named <code>seqP</code> which allows you to define when
a sound within a list starts and ends. The code below contains three
separate patterns in a &quot;stack&quot;, but each has different start times 
(zero cycles, eight cycles, and sixteen cycles, respectively). All
patterns stop after 128 cycles:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">seqP</span> <span class="p">[</span> 
  <span class="p">(</span><span class="mi">0</span><span class="p">,</span> <span class="mi">128</span><span class="p">,</span> <span class="n">sound</span> <span class="s">&quot;bd bd*2&quot;</span><span class="p">),</span> 
  <span class="p">(</span><span class="mi">8</span><span class="p">,</span> <span class="mi">128</span><span class="p">,</span> <span class="n">sound</span> <span class="s">&quot;hh*2 [sn cp] cp future*4&quot;</span><span class="p">),</span> 
  <span class="p">(</span><span class="mi">16</span><span class="p">,</span> <span class="mi">128</span><span class="p">,</span> <span class="n">sound</span> <span class="p">(</span><span class="n">samples</span> <span class="s">&quot;arpy*8&quot;</span> <span class="p">(</span><span class="n">run</span> <span class="mi">16</span><span class="p">)))</span>
<span class="p">]</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="slowcat" class="tidal-toc-heading">slowcat</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">slowcat</span> <span class="ow">::</span> <span class="p">[</span><span class="kt">Pattern</span> <span class="n">a</span><span class="p">]</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p><code>slowcat</code> concatenates a list of patterns into a new pattern; each pattern in the list will maintain its 
original duration. <code>slowcat</code> is similar to <code>cat</code>, except that pattern lengths are not changed. Examples:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">slowcat</span> <span class="p">[</span><span class="n">sound</span> <span class="s">&quot;bd*2 sn&quot;</span><span class="p">,</span> <span class="n">sound</span> <span class="s">&quot;arpy jvbass*2&quot;</span><span class="p">]</span>
<span class="nf">d1</span> <span class="o">$</span> <span class="n">slowcat</span> <span class="p">[</span><span class="n">sound</span> <span class="s">&quot;bd*2 sn&quot;</span><span class="p">,</span> <span class="n">sound</span> <span class="s">&quot;arpy jvbass*2&quot;</span><span class="p">,</span> <span class="n">sound</span> <span class="s">&quot;drum*2&quot;</span><span class="p">]</span>
<span class="nf">d1</span> <span class="o">$</span> <span class="n">slowcat</span> <span class="p">[</span><span class="n">sound</span> <span class="s">&quot;bd*2 sn&quot;</span><span class="p">,</span> <span class="n">sound</span> <span class="s">&quot;jvbass*3&quot;</span><span class="p">,</span> <span class="n">sound</span> <span class="s">&quot;drum*2&quot;</span><span class="p">,</span> <span class="n">sound</span> <span class="s">&quot;ht mt&quot;</span><span class="p">]</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="spin" class="tidal-toc-heading">spin</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">spin</span> <span class="ow">::</span> <span class="kt">Int</span> <span class="n">n</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p><code>spin</code> will &quot;spin&quot; a layer up a pattern the given number of times, with each successive layer offset in time by an additional <code>1/n</code> of a cycle, and panned by an additional <code>1/n</code>. The result is a pattern that seems to spin around. This function works best on multichannel systems.</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">slow</span> <span class="mi">3</span> <span class="o">$</span> <span class="n">spin</span> <span class="mi">4</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;drum*3 tabla:4 [arpy:2 ~ arpy] [can:2 can:3]&quot;</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="stack" class="tidal-toc-heading">stack</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">stack</span> <span class="ow">::</span> <span class="p">[</span><span class="kt">Pattern</span> <span class="n">a</span><span class="p">]</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p><code>stack</code> takes a list of patterns and combines them into a new pattern by
playing all of the patterns in the list simultaneously.</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">stack</span> <span class="p">[</span> 
  <span class="n">sound</span> <span class="s">&quot;bd bd*2&quot;</span><span class="p">,</span> 
  <span class="n">sound</span> <span class="s">&quot;hh*2 [sn cp] cp future*4&quot;</span><span class="p">,</span> 
  <span class="n">sound</span> <span class="p">(</span><span class="n">samples</span> <span class="s">&quot;arpy*8&quot;</span> <span class="p">(</span><span class="n">run</span> <span class="mi">16</span><span class="p">))</span>
<span class="p">]</span>
</code></pre></div>
<p>This is useful if you want to use a transform or synth parameter on the entire 
stack:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">whenmod</span> <span class="mi">5</span> <span class="mi">3</span> <span class="p">(</span><span class="n">striate</span> <span class="mi">3</span><span class="p">)</span> <span class="o">$</span> <span class="n">stack</span> <span class="p">[</span> 
  <span class="n">sound</span> <span class="s">&quot;bd bd*2&quot;</span><span class="p">,</span> 
  <span class="n">sound</span> <span class="s">&quot;hh*2 [sn cp] cp future*4&quot;</span><span class="p">,</span> 
  <span class="n">sound</span> <span class="p">(</span><span class="n">samples</span> <span class="s">&quot;arpy*8&quot;</span> <span class="p">(</span><span class="n">run</span> <span class="mi">16</span><span class="p">))</span>
<span class="p">]</span> <span class="o">|+|</span> <span class="n">speed</span> <span class="s">&quot;[[1 0.8], [1.5 2]*2]/3&quot;</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="superimpose" class="tidal-toc-heading">superimpose</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">superimpose</span> <span class="n">f</span> <span class="n">p</span> <span class="ow">=</span> <span class="n">stack</span> <span class="p">[</span><span class="n">p</span><span class="p">,</span> <span class="n">f</span> <span class="n">p</span><span class="p">]</span>
</code></pre></div>
<p><code>superimpose</code> plays a modified version of a pattern at the same time as the original pattern,
resulting in two patterns being played at the same time.</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">superimpose</span> <span class="p">(</span><span class="n">density</span> <span class="mi">2</span><span class="p">)</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bd sn [cp ht] hh&quot;</span>
<span class="nf">d1</span> <span class="o">$</span> <span class="n">superimpose</span> <span class="p">((</span><span class="o">|+|</span> <span class="n">speed</span> <span class="s">&quot;2&quot;</span><span class="p">)</span> <span class="o">.</span> <span class="p">(</span><span class="mf">0.125</span> <span class="o">&lt;~</span><span class="p">))</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bd sn cp hh&quot;</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="weave" class="tidal-toc-heading">weave</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">weave</span> <span class="ow">::</span> <span class="kt">Rational</span> <span class="ow">-&gt;</span> <span class="kt">OscPattern</span> <span class="ow">-&gt;</span> <span class="p">[</span><span class="kt">OscPattern</span><span class="p">]</span> <span class="ow">-&gt;</span> <span class="kt">OscPattern</span>
<span class="nf">weave&#39;</span> <span class="ow">::</span> <span class="kt">Rational</span> <span class="ow">-&gt;</span> <span class="kt">OscPattern</span> <span class="ow">-&gt;</span> <span class="p">[</span><span class="kt">OscPattern</span> <span class="ow">-&gt;</span> <span class="kt">OscPattern</span><span class="p">]</span> <span class="ow">-&gt;</span> <span class="kt">OscPattern</span>
</code></pre></div>
<p><code>weave</code> applies a function smoothly over an array of different patterns. It uses an <code>OscPattern</code> to
apply the function at different levels to each pattern, creating a weaving effect.</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">weave</span> <span class="mi">3</span> <span class="p">(</span><span class="n">shape</span> <span class="o">$</span> <span class="n">sine1</span><span class="p">)</span> <span class="p">[</span><span class="n">sound</span> <span class="s">&quot;bd [sn drum:2*2] bd*2 [sn drum:1]&quot;</span><span class="p">,</span> <span class="n">sound</span> <span class="s">&quot;arpy*8 ~&quot;</span><span class="p">]</span> 
</code></pre></div>
<p><code>weave&#39;</code> is similar in that it blends functions at the same time at different amounts over a pattern:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">weave&#39;</span> <span class="mi">3</span> <span class="p">(</span><span class="n">sound</span> <span class="s">&quot;bd [sn drum:2*2] bd*2 [sn drum:1]&quot;</span><span class="p">)</span> <span class="p">[</span><span class="n">density</span> <span class="mi">2</span><span class="p">,</span> <span class="p">(</span><span class="o">|+|</span> <span class="n">speed</span> <span class="s">&quot;0.5&quot;</span><span class="p">),</span> <span class="n">chop</span> <span class="mi">16</span><span class="p">]</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="wedge" class="tidal-toc-heading">wedge</h1>
                         <div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">wedge</span> <span class="ow">::</span> <span class="kt">Time</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span> <span class="ow">-&gt;</span> <span class="kt">Pattern</span> <span class="n">a</span>
</code></pre></div>
<p><code>wedge</code> combines two patterns by squashing two patterns into a single pattern cycle.
It takes a ratio as the first argument. The ratio determines what percentage of the
pattern cycle is taken up by the first pattern. The second pattern fills in the
remainder of the pattern cycle.</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">wedge</span> <span class="p">(</span><span class="mi">1</span><span class="o">/</span><span class="mi">4</span><span class="p">)</span> <span class="p">(</span><span class="n">sound</span> <span class="s">&quot;bd*2 arpy*3 cp sn*2&quot;</span><span class="p">)</span> <span class="p">(</span><span class="n">sound</span> <span class="s">&quot;odx [feel future]*2 hh hh&quot;</span><span class="p">)</span>
</code></pre></div>
                    </article>
                    
                    
                </section>
                  
                <section>
                    <header>
                        <h1 id="synth_parameters" class="tidal-toc-heading">Synth Parameters</h1>
                    </header>

                     
                    
                    <article>
                         <p>Synth parameters generate or affect sample playback. These are the
synthesis parameters you can use:</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="accelerate" class="tidal-toc-heading">accelerate</h1>
                         <p>a pattern of numbers that speed up (or slow down) samples while they play.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="bandf" class="tidal-toc-heading">bandf</h1>
                         <p>a pattern of numbers from 0 to 1. Sets the center frequency of the band-pass filter.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="bandq" class="tidal-toc-heading">bandq</h1>
                         <p>a pattern of numbers from 0 to 1. Sets the q-factor of the band-pass filter.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="begin" class="tidal-toc-heading">begin</h1>
                         <p>a pattern of numbers from 0 to 1. Skips the beginning of each sample, e.g. <code>0.25</code> to cut off the first quarter from each sample.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="coarse" class="tidal-toc-heading">coarse</h1>
                         <p>fake-resampling, a pattern of numbers for lowering the sample rate, i.e. 1 for original 2 for half, 3 for a third and so on.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="crush" class="tidal-toc-heading">crush</h1>
                         <p>bit crushing, a pattern of numbers from 1 for drastic reduction in bit-depth to 16 for barely no reduction.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="cutoff" class="tidal-toc-heading">cutoff</h1>
                         <p>a pattern of numbers from 0 to 1. Applies the cutoff frequency of the low-pass filter.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="delay" class="tidal-toc-heading">delay</h1>
                         <p>a pattern of numbers from 0 to 1. Sets the level of the delay signal.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="delayfeedback" class="tidal-toc-heading">delayfeedback</h1>
                         <p>a pattern of numbers from 0 to 1. Sets the amount of delay feedback.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="delaytime" class="tidal-toc-heading">delaytime</h1>
                         <p>a pattern of numbers from 0 to 1. Sets the length of the delay.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="end" class="tidal-toc-heading">end</h1>
                         <p>the same as <code>begin</code>, but cuts the end off samples, shortening them;
  e.g. <code>0.75</code> to cut off the last quarter of each sample.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="gain" class="tidal-toc-heading">gain</h1>
                         <p>a pattern of numbers that specify volume. Values less than 1 make the sound quieter. Values greater than 1 make the sound louder.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="hcutoff" class="tidal-toc-heading">hcutoff</h1>
                         <p>a pattern of numbers from 0 to 1. Applies the cutoff frequency of the high-pass filter.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="hresonance" class="tidal-toc-heading">hresonance</h1>
                         <p>a pattern of numbers from 0 to 1. Applies the resonance of the high-pass filter.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="pan" class="tidal-toc-heading">pan</h1>
                         <p>a pattern of numbers between 0 and 1, from left to right (assuming stereo)</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="resonance" class="tidal-toc-heading">resonance</h1>
                         <p>a pattern of numbers from 0 to 1. Applies the resonance of the low-pass filter.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="shape" class="tidal-toc-heading">shape</h1>
                         <p>wave shaping distortion, a pattern of numbers from 0 for no distortion up to 1 for loads of distortion</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="sound" class="tidal-toc-heading">sound</h1>
                         <p>a pattern of strings representing sound sample names (required)</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="speed" class="tidal-toc-heading">speed</h1>
                         <p>a pattern of numbers from 0 to 1, which changes the speed of sample playback, i.e. a cheap way of changing pitch</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="unit" class="tidal-toc-heading">unit</h1>
                         <p>only accepts a value of &quot;c&quot;. Used in conjunction with <code>speed</code>, it time-stretches a sample to fit in a cycle.</p>

                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="vowel" class="tidal-toc-heading">vowel</h1>
                         <p>formant filter to make things sound like vowels, a pattern of either <code>a</code>, <code>e</code>, <code>i</code>, <code>o</code> or <code>u</code>. Use a rest (<code>~</code>) for no effect.</p>

                    </article>
                    
                    
                </section>
                  
                <section>
                    <header>
                        <h1 id="utility" class="tidal-toc-heading">Utility</h1>
                    </header>

                     
                    
                    <article>
                        
                        <h1 id="irand" class="tidal-toc-heading">irand</h1>
                         <p><code>irand n</code> generates a pattern of (pseudo-)random integers between <code>0</code> to <code>n-1</code> inclusive. Notably used to pick a random
samples from a folder:</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">sound</span> <span class="p">(</span><span class="n">samples</span> <span class="s">&quot;drum*4&quot;</span> <span class="p">(</span><span class="n">irand</span> <span class="mi">5</span><span class="p">))</span>
</code></pre></div>
                    </article>
                    
                     
                    
                    <article>
                        
                        <h1 id="rand" class="tidal-toc-heading">rand</h1>
                         <p><code>rand</code> generates a pattern of (pseudo-)random, floating point numbers between <code>0</code> and <code>1</code>.</p>
<div class="highlight"><pre><code class="language-haskell" data-lang="haskell"><span class="nf">d1</span> <span class="o">$</span> <span class="n">sound</span> <span class="s">&quot;bd*8&quot;</span> <span class="o">|+|</span> <span class="n">pan</span> <span class="n">rand</span>
</code></pre></div>
                    </article>
                    
 
