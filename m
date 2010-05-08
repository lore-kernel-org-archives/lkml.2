Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab0EHQKV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 12:10:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39967 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab0EHQKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 12:10:20 -0400
Date: Sat, 8 May 2010 18:10:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [GIT RFC PULL] RCU changes for 2.6.35
Message-ID: <20100508161005.GB29638@elte.hu>
References: <20100507212220.GA10465@linux.vnet.ibm.com>
 <20100508083421.GA11245@elte.hu>
 <20100508151001.GB2383@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100508151001.GB2383@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Sat, May 08, 2010 at 10:34:21AM +0200, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > Hello, Ingo,
> > > 
> > > Here is the first installment of RCU changes for 2.6.35.  These commits
> > > are based on top of the rcu/urgent set sent yesterday.  If you would rather
> > > rcu/urgent be merged into tip/core/rcu and then this set based on top of
> > > that, or some other arrangement, please let me know.
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next
> > 
> > FYI, it doesnt build on x86 allyesconfig:
> > 
> > In file included from kernel/rcutree.c:1961:
> > kernel/rcutree_plugin.h: In function ?rcu_needs_cpu?:
> > kernel/rcutree_plugin.h:1066: error: invalid type argument of ?->? (have ?struct rcu_dynticks?)
> > kernel/rcutree_plugin.h:1067: error: invalid type argument of ?->? (have ?struct rcu_dynticks?)
> 
> <red face>
> 
> I forgot to move CONFIG_RCU_FAST_NO_HZ from my development tests to my
> regression tests.  I have done so now.  I have also added allyesconfig
> to my compile tests, which I should have done long ago.
> 
> I am testing the fix, and will rebase the stack onto 2.6.34-rc7 when it
> comes out.

Cool, thanks Paul!

	Ingo
