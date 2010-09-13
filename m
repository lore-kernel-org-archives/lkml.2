Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab0IMOVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:21:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45494 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab0IMOVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:21:41 -0400
Date: Mon, 13 Sep 2010 16:21:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
Message-ID: <20100913142123.GA5056@elte.hu>
References: <1284231470.2251.52.camel@laptop>
 <AANLkTin0LOuTOcJPiZcZGeZMdqsy2dohyrREw2GGhddJ@mail.gmail.com>
 <1284237380.2251.56.camel@laptop>
 <AANLkTi=a91QX-FLURFWNsjbCS1bDLr6GqSpC4_uzm3ta@mail.gmail.com>
 <1284282392.2251.81.camel@laptop>
 <1284352547.7321.51.camel@marge.simson.net>
 <1284367295.2275.31.camel@laptop>
 <1284385967.17152.13.camel@gandalf.stny.rr.com>
 <1284386079.2275.290.camel@laptop>
 <1284386531.2275.297.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284386531.2275.297.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2762]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> IIRC kbuild likes the child to be late, it allows make to spawn more 
> kids and it'll got sleep on completion once it done anyway.

Yes - and this is especially true on "make -j<nr_cpus>" types of 
borderline workloads - the scheduling policy with the highest effective 
parallelism wins.

Thanks,

	Ingo
