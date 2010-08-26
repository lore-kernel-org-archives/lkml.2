Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab0HZXX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:23:28 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59694 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab0HZXXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:23:25 -0400
Date: Thu, 26 Aug 2010 16:23:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Joe Perches <joe@perches.com>,
        ksummit-2010-discuss@lists.linux-foundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2010-discuss] [PATCH] MAINTAINERS: add U: for URL of
 todo list, add RCU todo list
Message-ID: <20100826232323.GL2367@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100826154537.GA4874@linux.vnet.ibm.com>
 <1282837904.1875.64.camel@Joe-Laptop>
 <20100826161451.GB2367@linux.vnet.ibm.com>
 <1282839933.8133.11.camel@mulgrave.site>
 <20100826165044.GE2367@linux.vnet.ibm.com>
 <20100826230021.GA4098@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826230021.GA4098@xanatos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 04:00:21PM -0700, Sarah Sharp wrote:
> On Thu, Aug 26, 2010 at 09:50:44AM -0700, Paul E. McKenney wrote:
> > On Thu, Aug 26, 2010 at 11:25:33AM -0500, James Bottomley wrote:
> > > On Thu, 2010-08-26 at 09:14 -0700, Paul E. McKenney wrote:
> > > > On Thu, Aug 26, 2010 at 08:51:44AM -0700, Joe Perches wrote:
> > > > > On Thu, 2010-08-26 at 08:45 -0700, Paul E. McKenney wrote:
> > > > > > Since T: and L: are already taken, add U: for URL of todo list.
> > > > > > Also add the RCU todo list to both the RCU and RCUTORTURE projects.
> > > > > 
> > > > > Hi Paul
> > > > > 
> > > > > I think W: already works perfectly well for this use.
> > > > > 
> > > > > >From MAINTAINERS:
> > > > >         W: Web-page with status/info
> > > > > 
> > > > > > @@ -4801,6 +4802,7 @@ M:	Josh Triplett <josh@freedesktop.org>
> > > > > >  M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > > >  S:	Supported
> > > > > >  T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> > > > > > +U:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
> > > > > 
> > > > > W:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
> > > > > 
> > > > > >  F:	Documentation/RCU/torture.txt
> > > > > >  F:	kernel/rcutorture.c
> > > > > >  
> > > > > > @@ -4826,6 +4828,7 @@ M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > > >  W:	http://www.rdrop.com/users/paulmck/rclock/
> > > > > >  S:	Supported
> > > > > >  T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> > > > > > +U:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
> > > > > 
> > > > > W:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
> > > > 
> > > > OK, how about the following, then?
> > > 
> > > Got to say I really think overloading W which means web page/status
> > > information isn't a very good idea:
> > > 
> > > jejb@mulgrave:~/git/linux-2.6> grep -w 'W:' MAINTAINERS |wc -l
> > > 371
> > > 
> > > We already have ~400 of them ... how's anyone looking for a todo list
> > > going to find the right one in amongst all the others (assuming a newbie
> > > with no subject predisposition simply trying to find any todo list).
> > 
> > Hopefully the todo lists have "todo" or "TODO" in the URL.  ;-)
> 
> That may not be the case if you use a public todo list on
> rememberthemilk.com.  It doesn't make sense to end multiple todo list
> names with "todo" for on site that's specifically designed to help with
> todo lists.
> 
> I like the idea of a separate letter for todo lists URLs.

So do I!  ;-)

Another option for URLs not containing "todo" or "TODO" is something like:

W:	rememberthemilk.com (todo)

I suspect that most people would know not to include " (todo)" in
the string they fed to their browser.

Seem reasonable?

							Thanx, Paul
