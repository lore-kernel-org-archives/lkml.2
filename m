Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab1ANOa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:30:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37680 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab1ANOaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:30:52 -0500
Date: Fri, 14 Jan 2011 15:30:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        rmk+kernel@arm.linux.org.uk, weber@corscience.de
Subject: Re: [GIT PULL rcu/next] 2.6.38 fixes for RCU regressions
Message-ID: <20110114143038.GA16736@elte.hu>
References: <20110114134620.GA12672@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114134620.GA12672@linux.vnet.ibm.com>
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
> This pull request fixes a pair of RCU regressions introduced into 2.6.38.
> 
> These changes are available in the git repository at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next
> 
> These are against the current tip/core/rcu branch.
> 
> 							Thanx, Paul
> 
> ------------------>
> Paul E. McKenney (2):
>       rcu: demote SRCU_SYNCHRONIZE_DELAY from kernel-parameter status
>       rcu: avoid pointless blocked-task warnings
> 
>  init/Kconfig     |   15 ---------------
>  kernel/rcutiny.c |    3 ++-
>  kernel/srcu.c    |   15 +++++++++++++--
>  3 files changed, 15 insertions(+), 18 deletions(-)

Pulled, thanks a lot Paul!

	Ingo
