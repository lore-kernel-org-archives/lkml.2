Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528Ab2BBWc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:32:59 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:33046 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab2BBWc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:32:57 -0500
X-Originating-IP: 217.70.178.142
X-Originating-IP: 50.43.15.19
Date: Thu, 2 Feb 2012 14:32:36 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 01/41] rcu: Bring RTFP.txt up to date.
Message-ID: <20120202223236.GD9279@leaf>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202001814.GA29058@leaf>
 <20120202013305.GT2382@linux.vnet.ibm.com>
 <20120202020100.GK29058@leaf>
 <20120202164725.GL2518@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202164725.GL2518@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 08:47:25AM -0800, Paul E. McKenney wrote:
> On Wed, Feb 01, 2012 at 06:01:01PM -0800, Josh Triplett wrote:
> > On Wed, Feb 01, 2012 at 05:33:05PM -0800, Paul E. McKenney wrote:
> > > On Wed, Feb 01, 2012 at 04:18:14PM -0800, Josh Triplett wrote:
> > > > On Wed, Feb 01, 2012 at 11:41:19AM -0800, Paul E. McKenney wrote:
> > > > > @@ -173,6 +192,14 @@ Bibtex Entries
> > > > >  ,volume="5"
> > > > >  ,number="3"
> > > > >  ,pages="354-382"
> > > > > +,note="Available:
> > > > > +\url{http://portal.acm.org/citation.cfm?id=320619&dl=GUIDE,}
> > > > > +[Viewed December 3, 2007]"
> > > > 
> > > > I don't think it adds any value here to use \url{} to point to an ACM
> > > > paywall page.  The journal, volume, number, and title already provide
> > > > enough information for anyone to grab the article from their source of
> > > > choice.
> > > 
> > > The portal.acm.org URL is useful to people with subscriptions to ACM
> > > digital library.  But yes, I am expecting readers to understand how to
> > > use a search engine.  Judging from a few comments to some of my blog
> > > entries, not everyone has that understanding, but hey, they can't learn
> > > any younger!  ;-)
> > 
> > I just meant that various paywalls exist to provide access to published
> > papers, and anyone with a subscription to any such paywall will know how
> > to get papers from it.  Pointing to one in particular doesn't seem
> > appropriate.
> 
> But if they have a subscription (and many do via their employer
> or university, knowingly or not), then why not provide the URL as a
> convenience to them?  If they don't have a subscription, they are free
> to ignore the URL.

Any number of such subscription services exist, all of which have the
papers in question, and all of which remain obnoxious.  Promoting one of
them seems suboptimal.

In any case, it doesn't matter that much. *shrug*

> > > > > +# MathieuDesnoyers2007call_rcu_schedNeeded
> > > > > +@unpublished{MathieuDesnoyers2007call:rcu:schedNeeded
> > > > 
> > > > Why the comment here?
> > > 
> > > For me to sort out old papers using an earlier bibtex label.
> > 
> > Ah, fair enough.
> > 
> > > I had to
> > > change the name when latex started getting angry about underscores in
> > > bibtex labels.
> > 
> > \usepackage{underscore} didn't fix that?
> 
> With this package, underscores in bib fields are tolerated, but not in
> the bibtex tag itself.

Ah, that makes sense.  The former just gets copied through and formatted
for printing by LaTeX, while the latter gets processed internally, and
changing the processing of _ to make it displayable doesn't necessarily
help BibTeX know what to do with it internally.

> Or was not at one point, but in any case I am
> not going to the trouble of changing the tags back.  ;-)

Of course; just wondered if that *would* have fixed it.  Still seems
preferable to avoid the problem. :)

> > > > > +@techreport{PaulEMcKenney2011cyclicRCU
> > > > > +,author="Paul E. McKenney"
> > > > > +,title="Efficient Support of Consistent Cyclic Search With Read-Copy Update"
> > > > > +,institution="US Patent and Trademark Office"
> > > > > +,address="Washington, DC"
> > > > > +,year="2008"
> > > > 
> > > > Why does this use the tag PaulEMcKenney2011cyclicRCU given the year of
> > > > 2008?
> > > 
> > > Application date vs. grant date.
> > 
> > Not in this case, though.  This one should have the year as either 2008
> > or 2010 depending on which date you count.
> 
> Odd.  Color me confused.  This is 7,426,511, which was filed in 2004 and
> granted in 2008.  Fixed.  I think, anyway.  I am -so- confused!  ;-)

I think I can clear up the confusion here.  Three different relevant
patents exist:

- Patent 7,426,511, titled "Efficient support of consistent cyclic
  search with read-copy-update", filed 2004-03-08 and granted
  2008-09-16.

- Patent 7,814,082, a continuation of 7,426,511, *also* titled
  "Efficient support of consistent cyclic search with read-copy-update",
  filed 2008-03-18 and granted 2010-10-12.  I grabbed the text of
  7,426,511 and this one, and ran them through git diff --no-index
  --color-words; it looks like 7,814,082 contains some very minor text
  revisions (not semantically significant), plus a change to the types
  of the claims (to claim a system and a computer program product,
  rather than a method).

- Patent 7,953,778, titled "Efficient support of consistent cyclic
  search with read-copy update and parallel updates", filed 2008-05-20
  and granted 2011-05-31.  As suggested by the title, this one adds
  parallel updates.

Your patch added citations for the first and third of those, 7,426,511
and 7,953,778, with BibTeX tags PaulEMcKenney2011cyclicRCU and
PaulEMcKenney2011cyclicparallelRCU.  I think you probably want to
replace the citation to 7,426,511 with a citation to 7,814,082, or cite
all three and annotate 7,426,511 as superseded by 7,814,082.  In any
case, you'll want to either drop or fix the years in the BibTeX tags.

> > > What bibtex entry type do you suggest for presentation-only conferences?
> > 
> > I use InProceedings for conferences in general:
> > 
> > @InProceedings{rcu-hash-lpc,
> >   author = {Josh Triplett},
> >   title = {{Scalable Concurrent Hash Tables via Relativistic Programming}},
> >   booktitle = {Linux Plumbers Conference 2009},
> >   year = 2009,
> >   address = {Portland, OR},
> >   month = {September}
> > }
> 
> Works for me!  Updated.

Thanks.

> > > > > +@article{JoshTriplett2010RPHash
> > > > > +,author="Josh Triplett and Paul E. McKenney and Jonathan Walpole"
> > > > > +,title="Scalable Concurrent Hash Tables via Relativistic Programming"
> > > > > +,journal="ACM Operating Systems Review"
> > > > > +,year=2010
> > > > > +,volume=44
> > > > > +,number=3
> > > > > +,month="July"
> > > > > +,annotation={
> > > > > +	RP fun with hash tables.
> > > > > +	http://portal.acm.org/citation.cfm?id=1842733.1842750
> > > > > +}}
> > > > 
> > > > Same comment about ACM URLs: not useful.
> > > 
> > > Same reply.
> > 
> > Same reply. :)
> 
> And, you guessed it:  Same reply.  ;-)

Same reply, and same *shrug*. :)

> > > > > +@techreport{JoshTriplett2011RPScalableCorrectOrdering
> > > > > +,author = {Josh Triplett and Philip W. Howard and Paul E. McKenney and Jonathan Walpole}
> > > > > +,title = {Scalable Correct Memory Ordering via Relativistic Programming}
> > > > > +,year = {2011}
> > > > > +,number = {11-03}
> > > > > +,institution = {Portland State University}
> > > > > +,note = {\url{http://www.cs.pdx.edu/pdfs/tr1103.pdf}}
> > > > > +}
> > > > 
> > > > I'd suggest dropping this tech report in favor of the much better
> > > > rewritten version that'll become available this month. :)
> > > 
> > > Sounds like a job for the next revision of RTFP.txt.  ;-)
> > 
> > Fair enough; I'll send a patch then. :)
> 
> I look forward to it!

Sent, with subject
"[PATCH] checkpatch: Check for quoted strings broken across lines".

- Josh Triplett
