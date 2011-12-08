Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab1LHX27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 18:28:59 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57692 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770Ab1LHX24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 18:28:56 -0500
X-Sasl-enc: CIUeSAfNxy8KthPSczRpFy9hee96+uZgpMzNLnO92jT6 1323386936
Date: Thu, 8 Dec 2011 15:27:09 -0800
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        devel@driverdev.osuosl.org, lttng-dev@lists.lttng.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 09/11] sched: export task_prio to GPL modules
Message-ID: <20111208232709.GA19820@kroah.com>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com>
 <1322776568.4699.52.camel@twins>
 <20111201221404.GC3365@kroah.com>
 <1322780830.4699.62.camel@twins>
 <20111201231751.GA4961@kroah.com>
 <20111205141749.GC28866@elte.hu>
 <20111206214446.GD1247@kroah.com>
 <20111208052354.GC9485@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208052354.GC9485@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 06:23:54AM +0100, Ingo Molnar wrote:
> 
> * Greg KH <greg@kroah.com> wrote:
> 
> > > Same goes for a whole lot of other crap that distros are 
> > > carrying. Would we want to merge a different CPU scheduler 
> > > or the 4g:4g patch or a completely new networking stack into 
> > > drivers/staging/? I don't think so.
> > 
> > Distros have new CPU schedulers and are still dragging the 4g 
> > split around?  A whole new networking stack would be 
> > interesting, and if self-contained, possible :)
> 
> The point being, there's legitimate reasons to refuse crap to an 
> area that *people care about* in a constructive manner.
> 
> There's no rejection of LTTNG in the "hey, go away, you are 
> doing it wrong" fashion - we are not holding a monopoly on how 
> instrumentation is supposed to be done and we've been wrong 
> before.
> 
> There's a highly constructive, open attitude towards LTTNG and 
> has been for years:
> 
>  " Mathieu, please split it up and integrate/unify it with the 
>    existing instrumentation features of Linux - and if it 
>    replaces existing stuff because an LTTNG component is 
>    superior then so be it. "

Ok, that's fair enough.

Mathieu, will you please work on this?  Or is there some reason you
don't feel this is possible?

> drivers/staging/ is a tool that i support in many (in fact most) 
> cases - but i don't support it if it does harm.
> 
> I'm supposed to say 'no' to extra complexity more often, and 
> this is definitely one of those cases:
> 
> Nacked-by: Ingo Molnar <mingo@elte.hu>
> 
> Also obviously NAK to the scheduler symbol export - that alone 
> should tell you that it's not just a "driver" - it deeply hooks 
> into the core kernel...
> 
> Please respect the NAK.

Will do, I'll go delete it from the staging-next tree now.

greg k-h
