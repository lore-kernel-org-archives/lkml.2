Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2BBBd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:33:59 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:47022 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2BBBd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:33:57 -0500
Date: Wed, 1 Feb 2012 17:33:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 01/41] rcu: Bring RTFP.txt up to date.
Message-ID: <20120202013305.GT2382@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202001814.GA29058@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202001814.GA29058@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020201-7408-0000-0000-000002558AAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 04:18:14PM -0800, Josh Triplett wrote:
> On Wed, Feb 01, 2012 at 11:41:19AM -0800, Paul E. McKenney wrote:
> > Add publications from 2010 and 2011 to RTFP.txt.

Thank you for looking this over!

> As well as numerous older BibTeX entries, and annotations for existing
> entries.

Hmmm...  How about "Update RTFP.txt"?  ;-)

> >  This document describes RCU-related publications, and is followed by
> >  the corresponding bibtex entries.  A number of the publications may
> > -be found at http://www.rdrop.com/users/paulmck/RCU/.
> > +be found at http://www.rdrop.com/users/paulmck/RCU/.  For others, browsers
> > +and search engines will usually find what you are looking for.
> >  
> >  The first thing resembling RCU was published in 1980, when Kung and Lehman
> >  [Kung80] recommended use of a garbage collector to defer destruction
> > @@ -160,7 +161,25 @@ which Mathieu Desnoyers is now maintaining [MathieuDesnoyers2009URCU]
> >  [MathieuDesnoyersPhD].  TINY_RCU [PaulEMcKenney2009BloatWatchRCU] made
> >  its appearance, as did expedited RCU [PaulEMcKenney2009expeditedRCU].
> >  The problem of resizeable RCU-protected hash tables may now be on a path
> > -to a solution [JoshTriplett2009RPHash].
> > +to a solution [JoshTriplett2009RPHash].  A few academic researchers are now
> > +using RCU to solve their parallel problems [HariKannan2009DynamicAnalysisRCU].
> > +
> > +2010 produced a simpler preemptible-RCU implementation based on TREE_RCU
> > +[PaulEMcKenney2010SimpleOptRCU], lockdep-RCU [PaulEMcKenney2010LockdepRCU],
> > +another resizeable RCU-protected hash table [HerbertXu2010RCUResizeHash]
> > +(this one consuming more memory, but allowing arbitrary changes in hash
> > +function, as required for DoS avoidance in the networking code), realization
> > +of the 2009 resizeable hash table [JoshTriplett2010RPHash], an update on the
> > +RCU API [PaulEMcKenney2010RCUAPI].
> 
> JoshTriplett2010RPHash refers to the OSR paper, which just provided a
> node-move algorithm, not a resizeable hash table.  Likewise,
> JoshTriplett2009RPHash just provides the node-move algorithm.  Only the
> 2011 USENIX ATC paper covered resizeable RCU-protected hash tables.

Thank you, I have fixed this.

> > @@ -173,6 +192,14 @@ Bibtex Entries
> >  ,volume="5"
> >  ,number="3"
> >  ,pages="354-382"
> > +,note="Available:
> > +\url{http://portal.acm.org/citation.cfm?id=320619&dl=GUIDE,}
> > +[Viewed December 3, 2007]"
> 
> I don't think it adds any value here to use \url{} to point to an ACM
> paywall page.  The journal, volume, number, and title already provide
> enough information for anyone to grab the article from their source of
> choice.

The portal.acm.org URL is useful to people with subscriptions to ACM
digital library.  But yes, I am expecting readers to understand how to
use a search engine.  Judging from a few comments to some of my blog
entries, not everyone has that understanding, but hey, they can't learn
any younger!  ;-)

> > +@article{BarbaraLiskov1988ArgusCACM
> > +,author = {Barbara Liskov}
> > +,title = {Distributed programming in {Argus}}
> > +,journal = {Commun. ACM}
> > +,volume = {31}
> > +,number = {3}
> > +,year = {1988}
> > +,issn = {0001-0782}
> > +,pages = {300--312}
> > +,doi = {http://doi.acm.org/10.1145/42392.42399}
> 
> Similarly I don't think a DOI provides any value; it just redirects to
> the same ACM paywall.  The ACM sticks one into the BibTeX entries they
> autogenerate, but I'd suggest stripping it out.  This goes for the
> several other entries in this patch that add DOI URLs of various forms.
> 
> > +@unpublished{PaulEMcKenney2007WG21DDOatomics
> > +,Author="Paul E. McKenney and Hans-J. Boehm and Lawrence Crowl"
> > +,Title="C++ Data-Dependency Ordering: Atomics and Memory Model"
> > +,month="August"
> > +,day="3"
> > +,year="2007"
> > +,note="Available:
> > +\url{http://open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2664.htm}
> > +[Viewed December 7, 2009]"
> > +,annotation="
> > +	RCU for C++, parts 1 and 2.
> > +"
> > +}
> > +
> > +@unpublished{PaulEMcKenney2007WG21DDOannotation
> > +,Author="Paul E. McKenney and Lawrence Crowl"
> > +,Title="C++ Data-Dependency Ordering: Function Annotation"
> > +,month="September"
> > +,day="18"
> > +,year="2008"
> > +,note="Available:
> > +\url{http://open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2782.htm}
> > +[Viewed December 7, 2009]"
> > +,annotation="
> > +	RCU for C++, part 2, updated many times.
> > +"
> > +}
> 
> Considering their status as published documents of a standards
> organization, why do these two use @unpublished?  (The same goes for
> many other entries currently using @unpublished, but it seems
> particlarly notable here.)

Because the published version is behind a paywall.  ;-)

> > +# MathieuDesnoyers2007call_rcu_schedNeeded
> > +@unpublished{MathieuDesnoyers2007call:rcu:schedNeeded
> 
> Why the comment here?

For me to sort out old papers using an earlier bibtex label.  I had to
change the name when latex started getting angry about underscores in
bibtex labels.  But yes, it is completely irrelevant for RTFP.txt so I
have removed it.

> >  @article{DinakarGuniguntala2008IBMSysJ
> >  ,author="D. Guniguntala and P. E. McKenney and J. Triplett and J. Walpole"
> >  ,title="The read-copy-update mechanism for supporting real-time applications on shared-memory multiprocessor systems with {Linux}"
> >  ,Year="2008"
> > -,Month="April"
> > +,Month="May"
> 
> This article appeared in the issue labeled "April-June".  All of the
> references I've found for it say "April".  You could sensibly write
> either month="April" or month="April-June" (yes, you can do that in
> BibTeX), but I don't think month="May" makes sense.

Good point, fixed.

> >  ,journal="IBM Systems Journal"
> >  ,volume="47"
> >  ,number="2"
> > -,pages="@@-@@"
> > +,pages="221-236"
> > +,note="Available:
> > +\url{http://www.research.ibm.com/journal/sj/472/guniguntala.pdf}
> > +[Viewed April 24, 2008]"
> 
> That URL doesn't actually work anymore.

Ouch!  I removed it.

> > +@techreport{PaulEMcKenney2011cyclicRCU
> > +,author="Paul E. McKenney"
> > +,title="Efficient Support of Consistent Cyclic Search With Read-Copy Update"
> > +,institution="US Patent and Trademark Office"
> > +,address="Washington, DC"
> > +,year="2008"
> 
> Why does this use the tag PaulEMcKenney2011cyclicRCU given the year of
> 2008?

Application date vs. grant date.

> > +@unpublished{EvgeniyPolyakov2009EllipticsNetwork
> > +,Author="Evgeniy Polyakov"
> > +,Title="The Elliptics Network"
> > +,month="April"
> > +,day="17"
> > +,year="2009"
> > +,note="Available:
> > +\url{http://www.ioremap.net/projects/elliptics}
> > +[Viewed April 30, 2009]"
> > +,annotation="
> > +	Distributed hash table with transactions, using elliptic
> > +	hash functions to distribute data.
> > +"
> > +}
> 
> Could you add a note in this annotation about how this relates to RCU,
> and thus why it appears in this bibliography?

Hmmm...  I removed this as well.  Evgeniy was apparently considering
using user-level RCU, but last I heard did something else instead.

> >  @unpublished{JoshTriplett2009RPHash
> >  ,Author="Josh Triplett"
> >  ,Title="Scalable concurrent hash tables via relativistic programming"
> > @@ -860,6 +2146,7 @@ Revised:
> >  ,note="Linux Plumbers Conference presentation"
> >  ,annotation="
> >  	RP fun with hash tables.
> > +	Superseded by JoshTriplett2010RPHash
> 
> No, the OSR paper doesn't supercede the LPC presentation.  Also, not
> @unpublished (which applies to quite a few other entries here, but in
> particular this one).

I did s/Superseded by/See also/ -- is that OK?

What bibtex entry type do you suggest for presentation-only conferences?

> > +@article{JoshTriplett2010RPHash
> > +,author="Josh Triplett and Paul E. McKenney and Jonathan Walpole"
> > +,title="Scalable Concurrent Hash Tables via Relativistic Programming"
> > +,journal="ACM Operating Systems Review"
> > +,year=2010
> > +,volume=44
> > +,number=3
> > +,month="July"
> > +,annotation={
> > +	RP fun with hash tables.
> > +	http://portal.acm.org/citation.cfm?id=1842733.1842750
> > +}}
> 
> Same comment about ACM URLs: not useful.

Same reply.

> > +@techreport{JoshTriplett2011RPScalableCorrectOrdering
> > +,author = {Josh Triplett and Philip W. Howard and Paul E. McKenney and Jonathan Walpole}
> > +,title = {Scalable Correct Memory Ordering via Relativistic Programming}
> > +,year = {2011}
> > +,number = {11-03}
> > +,institution = {Portland State University}
> > +,note = {\url{http://www.cs.pdx.edu/pdfs/tr1103.pdf}}
> > +}
> 
> I'd suggest dropping this tech report in favor of the much better
> rewritten version that'll become available this month. :)

Sounds like a job for the next revision of RTFP.txt.  ;-)

							Thanx, Paul

