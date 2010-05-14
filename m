Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab0ENGQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 02:16:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37949 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab0ENGQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 02:16:28 -0400
Date: Fri, 14 May 2010 08:15:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [GIT PULL] rcu: infrastructure for debugobjects checking
Message-ID: <20100514061543.GA24938@elte.hu>
References: <20100513230651.GA24426@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513230651.GA24426@linux.vnet.ibm.com>
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
> Here are the first three commits from Mathieu's debugobjects series
> (http://lwn.net/Articles/387344/).  The first two provide the debugobjects
> infrastructure and the RCU APIs, and the third applies these APIs to
> the RCU implementation itself.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next
> 
> Once these three reach mainline, I will submit the next six commits
> to their respective trees (powerpc, block, staging, fs, mm, and selinux).
> The maintainers have been CCed on the the earlier LKML patchsets.
> Once these six commits reach mainline, I will send you a pull request
> for the remaining two commits.
> 
> Then on to Arnd's "sparse" checks, which are still being refined.
> 
> 							Thanx, Paul
> 
> ------------------>
>  Mathieu Desnoyers (2)
> 	 Debugobjects transition check
> 	 rcu head introduce rcu head init on stack
> 
>  Paul E. McKenney (1)
> 	 rcu: remove all rcu head initializations, except on_stack initializations
> 
>  include/linux/debugobjects.h |   11 ++++++++
>  include/linux/init_task.h    |    1 -
>  include/linux/rcupdate.h     |    8 +++++
>  kernel/rcutiny.c             |    6 ++++
>  kernel/rcutorture.c          |    2 +
>  kernel/rcutree.c             |    4 +++
>  kernel/rcutree_plugin.h      |    2 +
>  lib/debugobjects.c           |   59 +++++++++++++++++++++++++++++++++++++++--
>  8 files changed, 89 insertions(+), 4 deletions(-)

Pulled, thanks Paul!

	Ingo
