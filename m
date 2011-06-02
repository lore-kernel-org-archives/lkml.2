Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab1FBHpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 03:45:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54506 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758881Ab1FBHpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 03:45:49 -0400
Date: Thu, 2 Jun 2011 09:45:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com, torvalds@linux-foundation.org
Subject: Re: perf: definition of a "regression"
Message-ID: <20110602074530.GF2150@elte.hu>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>
 <1306182141.2497.5.camel@laptop>
 <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>
 <1306233036.2497.15.camel@laptop>
 <alpine.DEB.2.00.1105272332400.9313@cl320.eecs.utk.edu>
 <1306578144.1200.1150.camel@twins>
 <alpine.DEB.2.00.1105280918510.27439@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105280918510.27439@cl320.eecs.utk.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vweaver1@eecs.utk.edu> wrote:

> On Sat, 28 May 2011, Peter Zijlstra wrote:
> 
> > On Fri, 2011-05-27 at 23:38 -0400, Vince Weaver wrote:
> > > on that note (and while trying to document exactly what the ioctls do) it 
> > > seems that a PERF_EVENT_IOC_REFRESH with an argument of anything higher 
> > > than one does not work on kernels 2.6.36 and newer.  The behavior acts
> > > as if 1 was passed, even if you pass in, say, 3.
> > 
> > Urgh, no that should definitely work. Thanks for the test-case, I'll
> > work on that (probably not until Monday though, but who knows).
> 
> So wait, the two regressions I found in 2.6.37 are WONTFIX because 
> they are too old, even though they break existing userspace code?
> 
> And this older regression in 2.6.36 is going to be fixed, even 
> though perf, PAPI, and libpfm4 don't trigger the buggy 
> functionality at all?

Btw., these considerations are flexible and we can reconsider and 
change the WONTFIX if there's a patch available and doesn't look 
horrible to backport. We can also mark fixes that havent been marked 
-stable originally as -stable later on, etc.

So please don't feel needlessly bitter about past decisions: when 
there's some good technical solution to a problem (or we were plain 
out wrong about a decision) we try hard not to stand in the way.

Thanks,

	Ingo
