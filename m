Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab0EHIey (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 04:34:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57103 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab0EHIex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 04:34:53 -0400
Date: Sat, 8 May 2010 10:34:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [GIT RFC PULL] RCU changes for 2.6.35
Message-ID: <20100508083421.GA11245@elte.hu>
References: <20100507212220.GA10465@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507212220.GA10465@linux.vnet.ibm.com>
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

> Hello, Ingo,
> 
> Here is the first installment of RCU changes for 2.6.35.  These commits
> are based on top of the rcu/urgent set sent yesterday.  If you would rather
> rcu/urgent be merged into tip/core/rcu and then this set based on top of
> that, or some other arrangement, please let me know.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next

FYI, it doesnt build on x86 allyesconfig:

In file included from kernel/rcutree.c:1961:
kernel/rcutree_plugin.h: In function ?rcu_needs_cpu?:
kernel/rcutree_plugin.h:1066: error: invalid type argument of ?->? (have ?struct rcu_dynticks?)
kernel/rcutree_plugin.h:1067: error: invalid type argument of ?->? (have ?struct rcu_dynticks?)

Thanks,

	Ingo
