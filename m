Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020Ab2CMIrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:47:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59530 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab2CMIrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:47:39 -0400
Date: Tue, 13 Mar 2012 08:47:13 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: linux-next: manual merge of the arm tree with Linus' tree
Message-ID: <20120313084713.GB27560@flint.arm.linux.org.uk>
References: <20120313110840.7b444deb6b1bb902c15f3cdf@canb.auug.org.au> <20120313061622.GA24357@elte.hu> <20120313083310.GA27560@flint.arm.linux.org.uk> <20120313083630.GA10131@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313083630.GA10131@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 09:36:30AM +0100, Ingo Molnar wrote:
> 
> * Russell King <rmk@arm.linux.org.uk> wrote:
> 
> > On Tue, Mar 13, 2012 at 07:16:22AM +0100, Ingo Molnar wrote:
> > > 
> > > * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > 
> > > > Hi Russell,
> > > > 
> > > > Today's linux-next merge of the arm tree got a conflict in
> > > > kernel/sched/core.c between commit 8c79a045fd59 ("sched/events: Revert
> > > > trace_sched_stat_sleeptime()") from Linus' tree and commit 1cf00341547a
> > > > ("sched: Introduce the finish_arch_post_lock_switch() scheduler hook")
> > > > from the arm tree.
> > > > 
> > > > Just context changes.  I fixed it up (see below) and can carry the fix as
> > > > necessary.
> > > 
> > > This commit seems simple enough and has PeterZ's ack, but if 
> > > there are more scheduler patches coming in this area then 
> > > please send it to the scheduler tree first: we can create a 
> > > pullable, stable topic branch for it which the ARM tree can 
> > > then use.
> > > 
> > > That approach would also avoid conflicts as a side effect.
> > 
> > Please check your mailbox:
> 
> I'm aware of that old thread, I'd just prefer to hear about your 
> plans patching the scheduler *before* you commit it to 
> linux-next ;-)
> 
> Please make sure none of these scheduler patches go to the ARM 
> tree without a proper Git space solution that involves the 
> scheduler folks.

Sorry, you're blaming the wrong person.  I got the commit via a pull,
not via a patch.

If that's how you want to run your bit of the kernel, then please be more
responsive when you're sent patches and say how you want to handle things.
Don't ignore patches and then blame people when conflicts happen.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
