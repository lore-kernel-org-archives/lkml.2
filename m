Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761323Ab1EASbo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 14:31:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46500 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab1EASbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 14:31:43 -0400
Date: Sun, 1 May 2011 20:31:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Pekka Enberg <penberg@kernel.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: re-enable Nehalem raw Offcore-Events support
Message-ID: <20110501183120.GA29964@elte.hu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
 <20110429164227.GA25491@elte.hu>
 <alpine.DEB.2.00.1104291353310.23685@cl320.eecs.utk.edu>
 <20110429185741.GB10217@elte.hu>
 <alpine.DEB.2.00.1104292200110.9459@cl320.eecs.utk.edu>
 <BANLkTimOcaFRxyr=sfdNbe0MXGWu9u1o1w@mail.gmail.com>
 <alpine.DEB.2.00.1104301641060.7288@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104301641060.7288@cl320.eecs.utk.edu>
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

> I spend a lot of time dealing with developers who use perf-counter related 
> interfaces all the time.  They complain to me *constantly* about the 
> drawbacks of perf_events, because PAPI is one step up from the kernel.
> 
> I try to get them to interact with the kernel people, but they won't.  Do you 
> know why?  Because they feel like the perf_events developers are rude at 
> best, unhelpful in general, and actively anti-anyone-not-using-perf.

Arnaldo, the maintainer of perf tooling (and with whom most users complaining 
about perf would be interacting) is one of the most responsive maintainers and 
developers i've ever seen. I have not seen him brush off a single user 
bugreport or complaint, ever - let alone be 'unhelpful' or be anti-anyone. 
Ditto for Peter.

They didnt even brush *you* off, ever.

Let me guess, you just made that argument up, right?

	Ingo
