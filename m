Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003Ab2CMIdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:33:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38330 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369Ab2CMIdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:33:36 -0400
Date: Tue, 13 Mar 2012 08:33:10 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: linux-next: manual merge of the arm tree with Linus' tree
Message-ID: <20120313083310.GA27560@flint.arm.linux.org.uk>
References: <20120313110840.7b444deb6b1bb902c15f3cdf@canb.auug.org.au> <20120313061622.GA24357@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313061622.GA24357@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 07:16:22AM +0100, Ingo Molnar wrote:
> 
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Russell,
> > 
> > Today's linux-next merge of the arm tree got a conflict in
> > kernel/sched/core.c between commit 8c79a045fd59 ("sched/events: Revert
> > trace_sched_stat_sleeptime()") from Linus' tree and commit 1cf00341547a
> > ("sched: Introduce the finish_arch_post_lock_switch() scheduler hook")
> > from the arm tree.
> > 
> > Just context changes.  I fixed it up (see below) and can carry the fix as
> > necessary.
> 
> This commit seems simple enough and has PeterZ's ack, but if 
> there are more scheduler patches coming in this area then please 
> send it to the scheduler tree first: we can create a pullable, 
> stable topic branch for it which the ARM tree can then use.
> 
> That approach would also avoid conflicts as a side effect.

Please check your mailbox:

Date: Tue, 29 Nov 2011 12:22:27 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [RFC PATCH 1/6] sched: Introduce the finish_arch_post_lock_switch()
        scheduler hook

Date: Mon, 19 Dec 2011 14:57:48 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>
Subject: [RFC PATCH v2 1/6] sched: Introduce the finish_arch_post_lock_switch()
        scheduler hook

Date: Fri, 20 Jan 2012 17:42:27 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>
Subject: [PATCH v3 1/6] sched: Introduce the finish_arch_post_lock_switch()
        scheduler hook

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
