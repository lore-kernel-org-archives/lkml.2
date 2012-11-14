Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab2KNHjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:39:36 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44179 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315Ab2KNHje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:39:34 -0500
Date: Wed, 14 Nov 2012 08:39:29 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: linux-next: Tree for Nov 14
Message-ID: <20121114073929.GA3130@gmail.com>
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
 <20121113213742.292f3ace.akpm@linux-foundation.org>
 <20121114064726.GA2537@gmail.com>
 <20121113225635.a848fd6c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113225635.a848fd6c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 14 Nov 2012 07:47:26 +0100 Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Wed, 14 Nov 2012 16:30:42 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > 
> > > > News: next-20121115 (i.e. tomorrow) will be the last release until
> > > > next-20121126 (which should be just be after -rc7, I guess - assuming
> > > > that Linus does not release v3.7 before then), so if you want something
> > > > in linux-next for a reasonable amount of testing, it should probably be
> > > > committed tomorrow.
> > > 
> > > It would help if the old sched/numa code wasn't in -next while 
> > > you're away.  That would give me a clean run at 3.7 and will 
> > > make it easier for others to integrate and test the four(!) 
> > > different autoschednumacore implementations on top of 
> > > linux-next.
> > > 
> > > Pretty please?
> > 
> > The next integration should have this solved: I have removed the 
> > old sched/numa bits, replaced by the latest rebased/reworked 
> > numa/core bits.
> > 
> 
> That solves one problem, but I still need to route around the 
> numa stuff when preparing the 3.8-rc1 merge.  Again!

I'm eyeing a v3.8 merge... modulo unforeseen problems. This has 
been going on for way too long.

numa/core performs very well, and the rest can be done 
iteratively.

The mm/ bits changed very little due to the latest rounds of 
review. Most of the discussion centered around specific 
implementational details and naming - and where we were wrong I 
changed the code - numa/core sums up the consensus so far.

If I missed anything let me know and I'll fix the code ASAP ...

Thanks,

	Ingo
