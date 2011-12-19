Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab1LSKvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 05:51:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40941 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab1LSKvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 05:51:21 -0500
Date: Mon, 19 Dec 2011 11:49:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        devel@driverdev.osuosl.org, lttng-dev@lists.lttng.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 09/11] sched: export task_prio to GPL modules
Message-ID: <20111219104915.GA19861@elte.hu>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com>
 <1322776568.4699.52.camel@twins>
 <20111201221404.GC3365@kroah.com>
 <1322780830.4699.62.camel@twins>
 <20111201231751.GA4961@kroah.com>
 <20111205141749.GC28866@elte.hu>
 <20111206214446.GD1247@kroah.com>
 <20111208052354.GC9485@elte.hu>
 <20111208232709.GA19820@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208232709.GA19820@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <greg@kroah.com> wrote:

> On Thu, Dec 08, 2011 at 06:23:54AM +0100, Ingo Molnar wrote:
> > 
> > * Greg KH <greg@kroah.com> wrote:
> > 
> > > > Same goes for a whole lot of other crap that distros are 
> > > > carrying. Would we want to merge a different CPU scheduler 
> > > > or the 4g:4g patch or a completely new networking stack into 
> > > > drivers/staging/? I don't think so.
> > > 
> > > Distros have new CPU schedulers and are still dragging the 4g 
> > > split around?  A whole new networking stack would be 
> > > interesting, and if self-contained, possible :)
> > 
> > The point being, there's legitimate reasons to refuse crap to an 
> > area that *people care about* in a constructive manner.
> > 
> > There's no rejection of LTTNG in the "hey, go away, you are 
> > doing it wrong" fashion - we are not holding a monopoly on how 
> > instrumentation is supposed to be done and we've been wrong 
> > before.
> > 
> > There's a highly constructive, open attitude towards LTTNG and 
> > has been for years:
> > 
> >  " Mathieu, please split it up and integrate/unify it with the 
> >    existing instrumentation features of Linux - and if it 
> >    replaces existing stuff because an LTTNG component is 
> >    superior then so be it. "
> 
> Ok, that's fair enough.
> 
> Mathieu, will you please work on this?  Or is there some 
> reason you don't feel this is possible?

Mathieu, any update on this? I don't want the LTTNG goodies to 
drop on the floor - we just have to integrate them properly.

If you 100% disagree with how specific things are done upstream 
right now then don't hold back: just replace existing mechanisms 
- that gives a starting point to discuss what the best way is 
forward.

> > drivers/staging/ is a tool that i support in many (in fact most) 
> > cases - but i don't support it if it does harm.
> > 
> > I'm supposed to say 'no' to extra complexity more often, and 
> > this is definitely one of those cases:
> > 
> > Nacked-by: Ingo Molnar <mingo@elte.hu>
> > 
> > Also obviously NAK to the scheduler symbol export - that alone 
> > should tell you that it's not just a "driver" - it deeply hooks 
> > into the core kernel...
> > 
> > Please respect the NAK.
> 
> Will do, I'll go delete it from the staging-next tree now.

Thanks Greg!

	Ingo
