Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2FTAlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 20:41:12 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:3470 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752623Ab2FTAlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 20:41:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgwKANMb4U95LJ3s/2dsb2JhbABFtEADgSyBCIIYAQEFOhwjEAgDGC4UJQMhE4gKuUcUixsad4UJA5Ukj36CcoFN
Date: Wed, 20 Jun 2012 10:40:54 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "ksummit-2012-discuss@lists.linux-foundation.org" 
	<ksummit-2012-discuss@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the
 question!
Message-ID: <20120620004054.GR25389@dastard>
References: <alpine.LFD.2.02.1206152313310.3086@ionos>
 <20120615233413.GB8894@kroah.com>
 <20120616123032.251dd101@pyramind.ukuu.org.uk>
 <1339864979.8267.55.camel@lade.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339864979.8267.55.camel@lade.trondhjem.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 04:43:05PM +0000, Myklebust, Trond wrote:
> On Sat, 2012-06-16 at 12:30 +0100, Alan Cox wrote:
> > On Fri, 15 Jun 2012 16:34:13 -0700
> > Greg KH <greg@kroah.com> wrote:
> > > On Sat, Jun 16, 2012 at 12:56:36AM +0200, Thomas Gleixner wrote:
> > > > So the main questions I want to raise on Kernel Summit are:
> > > > 
> > > >    - How do we cope with the need to review the increasing amount of
> > > >      (insane) patches and their potential integration?
> > One thing that seems to be working well are all the areas that have two
> > or more maintainers. As a simple statistical fault tolerance they don't
> > generally both have newborns, get the flu, change job or get yanked into
> > a critical customer problem by their employer on the same week.
> >
> > Right now we are doing it for real in some areas, and via the "screw
> > this, mail Andrew Morton" process for others, plus Linus fields some of
> > the really dumb ones. We could formalise some of that a bit more and
> > encourage more maintainers to actual team up with one of the other
> > contributors they trust.
> 
> If by "maintainer" you mean "patch reviewer", then I agree. Teaming up
> for the review process is the right thing to do, and is (as far as I
> know) what we were trying to resolve with the "Reviewed-by" tag.
> Formalising the review process and raising the status of developers that
> commit to reviewing patches is entirely the right thing to do. Actually
> maintaining trees of reviewed patches is the trivial part of the
> operation.
> 
> Perhaps the right thing to do is to start demanding that all patches
> that are submitted to the maintainer contain at least one "Reviewed-by:"
> tag?

The upside of this is that people who regularly review patches
(note: review, not ack) are more likely to have their patches
reviewed promptly by other people. i.e. this often devolves to a "I
scratch your back, you scratch mine" kind of arrangement.

In turn, this encourages prompt code review because it makes it more
likely that code is going to be reviewed quickly by others because
the others remember who reviewed their last patch-bomb quickly.

And the maintainer quickly learns whose reviews can be trusted, too,
which then leads to less load on the maintainer as reviewed-by tags
grow in trust value....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
