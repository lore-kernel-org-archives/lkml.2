Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937869Ab0CPNOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:14:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50523 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638Ab0CPNOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:14:30 -0400
Date: Tue, 16 Mar 2010 14:13:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, Chris Friesen <cfriesen@nortel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip] introduce sys_membarrier(): process-wide memory
 barrier (v9)
Message-ID: <20100316131336.GB24808@elte.hu>
References: <20100225232316.GA30196@Krystal>
 <20100304122304.GA6864@elte.hu>
 <alpine.LFD.2.00.1003040827100.7046@localhost.localdomain>
 <20100304175659.GA3255@Krystal>
 <20100315205312.GA31231@Krystal>
 <20100316073635.GC18448@elte.hu>
 <20100316075709.GL2869@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316075709.GL2869@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> On Tue, Mar 16, 2010 at 08:36:35AM +0100, Ingo Molnar wrote:
> > 
> > * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > 
> > > Unless this question is answered, Ingo's SA_RUNNING signal proposal, as 
> > > appealing as it may look at a first glance, falls into the 
> > > "fundamentally broken" category. [...]
> > 
> > How is it different from your syscall? I.e. which lines of code make the 
> > difference? We could certainly apply the (trivial) barrier change to 
> > context_switch().
> 
> I think it is just easy for userspace to misuse or think it does something 
> that it doesn't (because of races).

That wasnt my question though. The question i asked Mathieu was to show how 
SA_RUNNING is "fundamentally broken" for librcu use while sys_membarrier() is 
not?

This is really what he claims above. (i preserved the quote)

It must be a misunderstanding either on my side or on his side. (Once that is 
cleared we can discuss further usecases for SA_RUNNING.)

Thanks,

	Ingo
