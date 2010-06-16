Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab0FPFyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:54:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50558 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341Ab0FPFyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:54:53 -0400
Date: Wed, 16 Jun 2010 07:53:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, daniel.blueman@gmail.com,
       lizf@cn.fujitsu.com, miles.lane@gmail.com, manfred@colorfullife.com
Subject: Re: [GIT PULL rcu/urgent] yet more lockdep-RCU splat fixes
Message-ID: <20100616055358.GB17936@elte.hu>
References: <20100616042224.GA3892@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616042224.GA3892@linux.vnet.ibm.com>
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
> Here are a few more fixes for RCU-lockdep splats.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent
> 
> This is based off of v2.6.35-rc3.
> 
> 							Thanx, Paul
> 
> ------------------>
> Daniel J Blueman (1):
>       rcu: fix lockdep splat in wake_affine()
> 
> Paul E. McKenney (2):
>       rcu: fix scope of wake_affine()'s new RCU read-side critical section
>       idr: fix RCU lockdep splat in idr_get_next()
> 
>  kernel/sched_fair.c |    2 ++
>  lib/idr.c           |    4 ++--
>  2 files changed, 4 insertions(+), 2 deletions(-)

Pulled, thanks a lot Paul!

	Ingo
