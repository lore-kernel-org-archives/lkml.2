Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab0GCNL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 09:11:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38527 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab0GCNLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 09:11:55 -0400
Date: Sat, 3 Jul 2010 15:11:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, davem@davemloft.net,
       shemminger@linux-foundation.org, netdev@vger.kernel.org,
       eric.dumazet@gmail.com, sfr@canb.auug.org.au
Subject: Re: [GIT PULL rcu/urgent] revert ->br_port fix, obsoleted by netdev
 commit
Message-ID: <20100703131140.GD26067@elte.hu>
References: <20100701215655.GA24450@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701215655.GA24450@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1769]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> This pull request reverts commit 81bdf5bd, which has been obsoleted
> by commit f350a0a87374 from the netdev folks.  This conflict was caught
> in the -next tree.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next
> 
> 							Thanx, Paul
> 
> ------------------>
> Paul E. McKenney (1):
>       Revert "net: Make accesses to ->br_port safe for sparse RCU"
> 
>  include/linux/if_bridge.h           |    3 ---
>  net/bridge/br_fdb.c                 |    2 +-
>  net/bridge/br_private.h             |    5 -----
>  net/bridge/netfilter/ebt_redirect.c |    2 +-
>  net/bridge/netfilter/ebt_ulog.c     |    4 ++--
>  net/bridge/netfilter/ebtables.c     |    4 ++--
>  net/netfilter/nfnetlink_log.c       |    4 ++--
>  net/netfilter/nfnetlink_queue.c     |    4 ++--
>  8 files changed, 10 insertions(+), 18 deletions(-)

Pulled, thanks a lot Paul!

	Ingo
