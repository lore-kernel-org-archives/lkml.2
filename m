Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab1EPOaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:30:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45734 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab1EPOaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:30:16 -0400
Date: Mon, 16 May 2011 16:30:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110516143005.GA25245@elte.hu>
References: <20110513121906.GA3676@elte.hu>
 <20110513130414.GA6863@elte.hu>
 <20110513131218.GA7669@elte.hu>
 <20110513141431.GV2258@linux.vnet.ibm.com>
 <20110513150744.GE32688@elte.hu>
 <20110513162646.GW2258@linux.vnet.ibm.com>
 <20110516070808.GC24836@elte.hu>
 <20110516074822.GE2573@linux.vnet.ibm.com>
 <20110516115148.GA2421@elte.hu>
 <20110516122329.GA29356@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516122329.GA29356@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > I'll try it in any case.
> 
> oh, this was a new iteration, mea culpa!
> 
> And yes, it solves all problems for me as well. Mind pushing it as a fix? :-)

FYI, i am also getting the warning below with a defconfig.

	Ingo

initcall init_per_zone_wmark_min+0x0/0x5b returned 0 after 41 usecs
calling  kswapd_init+0x0/0x1d @ 1
------------[ cut here ]------------
WARNING: at kernel/rcutree.c:364 rcu_enter_nohz+0x4f/0x60()
Hardware name: System Product Name
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.39-rc7-tip-03260-gb177656-dirty #126707
Call Trace:
 [<c13974b6>] ? printk+0x18/0x1a
 [<c1038f0d>] warn_slowpath_common+0x6d/0xa0
 [<c1089bdf>] ? rcu_enter_nohz+0x4f/0x60
 [<c1089bdf>] ? rcu_enter_nohz+0x4f/0x60
 [<c1038f5d>] warn_slowpath_null+0x1d/0x20
 [<c1089bdf>] rcu_enter_nohz+0x4f/0x60
 [<c10639ca>] tick_nohz_stop_sched_tick+0x22a/0x470
 [<c1001685>] cpu_idle+0x65/0xe0
 [<c137d789>] rest_init+0xa1/0xa8
 [<c137d6e8>] ? reciprocal_value+0x48/0x48
 [<c156a6ef>] start_kernel+0x303/0x30b
 [<c156a1fd>] ? obsolete_checksetup+0x95/0x95
 [<c156a067>] i386_start_kernel+0x67/0x6d
---[ end trace fe4ebffb2b8ff187 ]---
initcall kswapd_init+0x0/0x1d returned 0 after 70614 usecs
calling  extfrag_debug_init+0x0/0x78 @ 1
initcall extfrag_debug_init+0x0/0x78 returned 0 after 79 usecs
