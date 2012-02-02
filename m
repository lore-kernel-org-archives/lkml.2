Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2BBQs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 11:48:28 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:52476 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab2BBQs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 11:48:26 -0500
Date: Thu, 2 Feb 2012 08:47:25 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 01/41] rcu: Bring RTFP.txt up to date.
Message-ID: <20120202164725.GL2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202001814.GA29058@leaf>
 <20120202013305.GT2382@linux.vnet.ibm.com>
 <20120202020100.GK29058@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202020100.GK29058@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020216-7408-0000-0000-0000025955CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 06:01:01PM -0800, Josh Triplett wrote:
> On Wed, Feb 01, 2012 at 05:33:05PM -0800, Paul E. McKenney wrote:
> > On Wed, Feb 01, 2012 at 04:18:14PM -0800, Josh Triplett wrote:
> > > On Wed, Feb 01, 2012 at 11:41:19AM -0800, Paul E. McKenney wrote:
> > > > @@ -173,6 +192,14 @@ Bibtex Entries
> > > >  ,volume="5"
> > > >  ,number="3"
> > > >  ,pages="354-382"
> > > > +,note="Available:
> > > > +\url{http://portal.acm.org/citation.cfm?id=320619&dl=GUIDE,}
> > > > +[Viewed December 3, 2007]"
> > > 
> > > I don't think it adds any value here to use \url{} to point to an ACM
> > > paywall page.  The journal, volume, number, and title already provide
> > > enough information for anyone to grab the article from their source of
> > > choice.
> > 
> > The portal.acm.org URL is useful to people with subscriptions to ACM
> > digital library.  But yes, I am expecting readers to understand how to
> > use a search engine.  Judging from a few comments to some of my blog
> > entries, not everyone has that understanding, but hey, they can't learn
> > any younger!  ;-)
> 
> I just meant that various paywalls exist to provide access to published
> papers, and anyone with a subscription to any such paywall will know how
> to get papers from it.  Pointing to one in particular doesn't seem
> appropriate.

But if they have a subscription (and many do via their employer
or university, knowingly or not), then why not provide the URL as a
convenience to them?  If they don't have a subscription, they are free
to ignore the URL.

> > > > +@article{BarbaraLiskov1988ArgusCACM
> > > > +,author = {Barbara Liskov}
> > > > +,title = {Distributed programming in {Argus}}
> > > > +,journal = {Commun. ACM}
> > > > +,volume = {31}
> > > > +,number = {3}
> > > > +,year = {1988}
> > > > +,issn = {0001-0782}
> > > > +,pages = {300--312}
> > > > +,doi = {http://doi.acm.org/10.1145/42392.42399}
> > > 
> > > Similarly I don't think a DOI provides any value; it just redirects to
> > > the same ACM paywall.  The ACM sticks one into the BibTeX entries they
> > > autogenerate, but I'd suggest stripping it out.  This goes for the
> > > several other entries in this patch that add DOI URLs of various forms.
> 
> As above.
> 
> > > > +@unpublished{PaulEMcKenney2007WG21DDOatomics
> > > > +,Author="Paul E. McKenney and Hans-J. Boehm and Lawrence Crowl"
> > > > +,Title="C++ Data-Dependency Ordering: Atomics and Memory Model"
> > > > +,month="August"
> > > > +,day="3"
> > > > +,year="2007"
> > > > +,note="Available:
> > > > +\url{http://open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2664.htm}
> > > > +[Viewed December 7, 2009]"
> > > > +,annotation="
> > > > +	RCU for C++, parts 1 and 2.
> > > > +"
> > > > +}
> > > > +
> > > > +@unpublished{PaulEMcKenney2007WG21DDOannotation
> > > > +,Author="Paul E. McKenney and Lawrence Crowl"
> > > > +,Title="C++ Data-Dependency Ordering: Function Annotation"
> > > > +,month="September"
> > > > +,day="18"
> > > > +,year="2008"
> > > > +,note="Available:
> > > > +\url{http://open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2782.htm}
> > > > +[Viewed December 7, 2009]"
> > > > +,annotation="
> > > > +	RCU for C++, part 2, updated many times.
> > > > +"
> > > > +}
> > > 
> > > Considering their status as published documents of a standards
> > > organization, why do these two use @unpublished?  (The same goes for
> > > many other entries currently using @unpublished, but it seems
> > > particlarly notable here.)
> > 
> > Because the published version is behind a paywall.  ;-)
> 
> The versions you linked to seem sufficiently published to me. :)
> 
> You could always change the note to "Preprint:".

Sold!  Updated them both.

> > > > +# MathieuDesnoyers2007call_rcu_schedNeeded
> > > > +@unpublished{MathieuDesnoyers2007call:rcu:schedNeeded
> > > 
> > > Why the comment here?
> > 
> > For me to sort out old papers using an earlier bibtex label.
> 
> Ah, fair enough.
> 
> > I had to
> > change the name when latex started getting angry about underscores in
> > bibtex labels.
> 
> \usepackage{underscore} didn't fix that?

With this package, underscores in bib fields are tolerated, but not in
the bibtex tag itself.  Or was not at one point, but in any case I am
not going to the trouble of changing the tags back.  ;-)

> > > > +@techreport{PaulEMcKenney2011cyclicRCU
> > > > +,author="Paul E. McKenney"
> > > > +,title="Efficient Support of Consistent Cyclic Search With Read-Copy Update"
> > > > +,institution="US Patent and Trademark Office"
> > > > +,address="Washington, DC"
> > > > +,year="2008"
> > > 
> > > Why does this use the tag PaulEMcKenney2011cyclicRCU given the year of
> > > 2008?
> > 
> > Application date vs. grant date.
> 
> Not in this case, though.  This one should have the year as either 2008
> or 2010 depending on which date you count.

Odd.  Color me confused.  This is 7,426,511, which was filed in 2004 and
granted in 2008.  Fixed.  I think, anyway.  I am -so- confused!  ;-)

> > > > +@unpublished{EvgeniyPolyakov2009EllipticsNetwork
> > > > +,Author="Evgeniy Polyakov"
> > > > +,Title="The Elliptics Network"
> > > > +,month="April"
> > > > +,day="17"
> > > > +,year="2009"
> > > > +,note="Available:
> > > > +\url{http://www.ioremap.net/projects/elliptics}
> > > > +[Viewed April 30, 2009]"
> > > > +,annotation="
> > > > +	Distributed hash table with transactions, using elliptic
> > > > +	hash functions to distribute data.
> > > > +"
> > > > +}
> > > 
> > > Could you add a note in this annotation about how this relates to RCU,
> > > and thus why it appears in this bibliography?
> > 
> > Hmmm...  I removed this as well.  Evgeniy was apparently considering
> > using user-level RCU, but last I heard did something else instead.
> 
> Ah, OK.
> 
> > > >  @unpublished{JoshTriplett2009RPHash
> > > >  ,Author="Josh Triplett"
> > > >  ,Title="Scalable concurrent hash tables via relativistic programming"
> > > > @@ -860,6 +2146,7 @@ Revised:
> > > >  ,note="Linux Plumbers Conference presentation"
> > > >  ,annotation="
> > > >  	RP fun with hash tables.
> > > > +	Superseded by JoshTriplett2010RPHash
> > > 
> > > No, the OSR paper doesn't supercede the LPC presentation.  Also, not
> > > @unpublished (which applies to quite a few other entries here, but in
> > > particular this one).
> > 
> > I did s/Superseded by/See also/ -- is that OK?
> 
> Seems sensible.
> 
> > What bibtex entry type do you suggest for presentation-only conferences?
> 
> I use InProceedings for conferences in general:
> 
> @InProceedings{rcu-hash-lpc,
>   author = {Josh Triplett},
>   title = {{Scalable Concurrent Hash Tables via Relativistic Programming}},
>   booktitle = {Linux Plumbers Conference 2009},
>   year = 2009,
>   address = {Portland, OR},
>   month = {September}
> }

Works for me!  Updated.

> > > > +@article{JoshTriplett2010RPHash
> > > > +,author="Josh Triplett and Paul E. McKenney and Jonathan Walpole"
> > > > +,title="Scalable Concurrent Hash Tables via Relativistic Programming"
> > > > +,journal="ACM Operating Systems Review"
> > > > +,year=2010
> > > > +,volume=44
> > > > +,number=3
> > > > +,month="July"
> > > > +,annotation={
> > > > +	RP fun with hash tables.
> > > > +	http://portal.acm.org/citation.cfm?id=1842733.1842750
> > > > +}}
> > > 
> > > Same comment about ACM URLs: not useful.
> > 
> > Same reply.
> 
> Same reply. :)

And, you guessed it:  Same reply.  ;-)

> > > > +@techreport{JoshTriplett2011RPScalableCorrectOrdering
> > > > +,author = {Josh Triplett and Philip W. Howard and Paul E. McKenney and Jonathan Walpole}
> > > > +,title = {Scalable Correct Memory Ordering via Relativistic Programming}
> > > > +,year = {2011}
> > > > +,number = {11-03}
> > > > +,institution = {Portland State University}
> > > > +,note = {\url{http://www.cs.pdx.edu/pdfs/tr1103.pdf}}
> > > > +}
> > > 
> > > I'd suggest dropping this tech report in favor of the much better
> > > rewritten version that'll become available this month. :)
> > 
> > Sounds like a job for the next revision of RTFP.txt.  ;-)
> 
> Fair enough; I'll send a patch then. :)

I look forward to it!

							Thanx, Paul

