Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab2KNINj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:13:39 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41950 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab2KNINh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:13:37 -0500
Date: Wed, 14 Nov 2012 00:13:32 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Ingo Molnar <mingo@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: linux-next: Tree for Nov 14
In-Reply-To: <20121114073929.GA3130@gmail.com>
Message-ID: <alpine.LNX.2.00.1211132346120.19216@eggly.anvils>
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au> <20121113213742.292f3ace.akpm@linux-foundation.org> <20121114064726.GA2537@gmail.com> <20121113225635.a848fd6c.akpm@linux-foundation.org> <20121114073929.GA3130@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 14 Nov 2012 07:47:26 +0100 Ingo Molnar <mingo@kernel.org> wrote:
> > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > On Wed, 14 Nov 2012 16:30:42 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > > 
> > > > > News: next-20121115 (i.e. tomorrow) will be the last release until
> > > > > next-20121126 (which should be just be after -rc7, I guess - assuming
> > > > > that Linus does not release v3.7 before then), so if you want something
> > > > > in linux-next for a reasonable amount of testing, it should probably be
> > > > > committed tomorrow.
> > > > 
> > > > It would help if the old sched/numa code wasn't in -next while 
> > > > you're away.  That would give me a clean run at 3.7 and will 
> > > > make it easier for others to integrate and test the four(!) 
> > > > different autoschednumacore implementations on top of 
> > > > linux-next.
> > > > 
> > > > Pretty please?
> > > 
> > > The next integration should have this solved: I have removed the 
> > > old sched/numa bits, replaced by the latest rebased/reworked 
> > > numa/core bits.
> > > 
> > 
> > That solves one problem, but I still need to route around the 
> > numa stuff when preparing the 3.8-rc1 merge.  Again!
> 
> I'm eyeing a v3.8 merge... modulo unforeseen problems. This has 
> been going on for way too long.
> 
> numa/core performs very well, and the rest can be done 
> iteratively.
> 
> The mm/ bits changed very little due to the latest rounds of 
> review. Most of the discussion centered around specific 
> implementational details and naming - and where we were wrong I 
> changed the code - numa/core sums up the consensus so far.
> 
> If I missed anything let me know and I'll fix the code ASAP ...

Please, Ingo, stop trying to force this in ahead of time, yet again.

People are still reviewing and comparing competing solutions.
Maybe this latest will prove to be closest to the right answer,
maybe it will not.  It's, what, about two days old right now?

If we had wanted to push in a good solution a little prematurely,
we would surely have chosen Andrea's AutoNUMA months ago, despite
efforts to block it; and maybe we shall still want to go that way.

Please, forget about v3.8, cut this branch out of linux-next,
and seek consensus around getting it right for v3.9.

I dislike speaking out in this way, because I'm well aware of
how very much more effort you and Peter and Andrea and Mel and
Rik and many others are making than I can manage - thank you all.

Hugh
