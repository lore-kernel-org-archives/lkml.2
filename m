Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062Ab2CMGQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:16:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39898 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab2CMGQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:16:37 -0400
Date: Tue, 13 Mar 2012 07:16:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: linux-next: manual merge of the arm tree with Linus' tree
Message-ID: <20120313061622.GA24357@elte.hu>
References: <20120313110840.7b444deb6b1bb902c15f3cdf@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313110840.7b444deb6b1bb902c15f3cdf@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Russell,
> 
> Today's linux-next merge of the arm tree got a conflict in
> kernel/sched/core.c between commit 8c79a045fd59 ("sched/events: Revert
> trace_sched_stat_sleeptime()") from Linus' tree and commit 1cf00341547a
> ("sched: Introduce the finish_arch_post_lock_switch() scheduler hook")
> from the arm tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

This commit seems simple enough and has PeterZ's ack, but if 
there are more scheduler patches coming in this area then please 
send it to the scheduler tree first: we can create a pullable, 
stable topic branch for it which the ARM tree can then use.

That approach would also avoid conflicts as a side effect.

Thanks,

	Ingo
