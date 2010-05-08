Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab0EHPKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 11:10:08 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52188 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab0EHPKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 11:10:06 -0400
Date: Sat, 8 May 2010 08:10:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [GIT RFC PULL] RCU changes for 2.6.35
Message-ID: <20100508151001.GB2383@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100507212220.GA10465@linux.vnet.ibm.com>
 <20100508083421.GA11245@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100508083421.GA11245@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 08, 2010 at 10:34:21AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Hello, Ingo,
> > 
> > Here is the first installment of RCU changes for 2.6.35.  These commits
> > are based on top of the rcu/urgent set sent yesterday.  If you would rather
> > rcu/urgent be merged into tip/core/rcu and then this set based on top of
> > that, or some other arrangement, please let me know.
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next
> 
> FYI, it doesnt build on x86 allyesconfig:
> 
> In file included from kernel/rcutree.c:1961:
> kernel/rcutree_plugin.h: In function ?rcu_needs_cpu?:
> kernel/rcutree_plugin.h:1066: error: invalid type argument of ?->? (have ?struct rcu_dynticks?)
> kernel/rcutree_plugin.h:1067: error: invalid type argument of ?->? (have ?struct rcu_dynticks?)

<red face>

I forgot to move CONFIG_RCU_FAST_NO_HZ from my development tests to my
regression tests.  I have done so now.  I have also added allyesconfig
to my compile tests, which I should have done long ago.

I am testing the fix, and will rebase the stack onto 2.6.34-rc7 when it
comes out.

							Thanx, Paul
