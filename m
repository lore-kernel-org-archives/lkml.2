Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524Ab1D3Usn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 16:48:43 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:35345 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab1D3Usm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 16:48:42 -0400
Date: Sat, 30 Apr 2011 16:47:06 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Pekka Enberg <penberg@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: re-enable Nehalem raw Offcore-Events support
In-Reply-To: <BANLkTimOcaFRxyr=sfdNbe0MXGWu9u1o1w@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1104301641060.7288@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu> <20110429164227.GA25491@elte.hu> <alpine.DEB.2.00.1104291353310.23685@cl320.eecs.utk.edu> <20110429185741.GB10217@elte.hu> <alpine.DEB.2.00.1104292200110.9459@cl320.eecs.utk.edu>
 <BANLkTimOcaFRxyr=sfdNbe0MXGWu9u1o1w@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Apr 2011, Pekka Enberg wrote:

> you've
> already managed to convince me that applying _any_ patch from you is a
> bad idea because the baggage that comes with it is simply not worth
> it.

well if it makes you feel better you can do a "git log" and search for my 
name and back out all the included perf related patches that have my name 
associated with them.  Then you can have a "vince-free" kernel without
all the "baggage".

> If you want to alienate other developers, keep doing what you're doing
> - otherwise consider changing your tactics. It's boring to watch you
> repeat the same mistakes over and over again.

I spend a lot of time dealing with developers who use perf-counter related 
interfaces all the time.  They complain to me *constantly* about the 
drawbacks of perf_events, because PAPI is one step up from the kernel.

I try to get them to interact with the kernel people, but they won't.  Do 
you know why?  Because they feel like the perf_events developers are rude 
at best, unhelpful in general, and actively anti-anyone-not-using-perf.

Most of them simply think it's not worth dealing with the perf_events 
people, even if it means hardship down the road.  I keep trying because I 
am foolishly idealistic at times.  So anyway all of my vitriol is the 
combined power of scores of disenfranchised developers, who were happy to 
work on kernel problems when the perfmon2 developers were running things, 
but now won't touch it with a 10-foot pole.

So make of that what you will, but things go both ways.  You can be as 
obnoxious as you want as a maintainer but don't expect people to send you 
patches if you are.

Vince

