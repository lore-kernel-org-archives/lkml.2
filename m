Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964943Ab2CMJ1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:27:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34353 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585Ab2CMJ1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:27:06 -0400
Date: Tue, 13 Mar 2012 10:26:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL/NEXT] sched/arch: Introduce the
 finish_arch_post_lock_switch() scheduler callback
Message-ID: <20120313092649.GA15406@elte.hu>
References: <20120313110840.7b444deb6b1bb902c15f3cdf@canb.auug.org.au>
 <20120313061622.GA24357@elte.hu>
 <20120313083310.GA27560@flint.arm.linux.org.uk>
 <20120313083630.GA10131@elte.hu>
 <20120313084713.GB27560@flint.arm.linux.org.uk>
 <20120313085628.GB6991@elte.hu>
 <20120313090040.GE27560@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313090040.GE27560@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Russell King <rmk@arm.linux.org.uk> wrote:

> On Tue, Mar 13, 2012 at 09:56:28AM +0100, Ingo Molnar wrote:
> > 
> > * Russell King <rmk@arm.linux.org.uk> wrote:
> > 
> > > Sorry, you're blaming the wrong person.  I got the commit via 
> > > a pull, not via a patch.
> > 
> > This is the most idiotic excuse I've ever read.
> 
> Sod this crap, I'm dropping Catalin's patches. [...]

As I said it in my first mail, doing that is unnecessary - but 
if you insist on being difficult then Catalin, feel free to pull 
the patch from tip:sched/arch:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/arch

   HEAD: 01f23e1630 sched/arch: Introduce the finish_arch_post_lock_switch() scheduler callback

it's v3.3-rc7 based so it will generate no conflict with 
linux-next. It only contains this commit so you can use it 
without pulling in other pending scheduler changes.

This is the trivial and easy Git based topic branch approach 
PeterZ asked Russell a month ago to consider:

   http://lkml.org/lkml/2012/2/16/232

which request Russell sadly ignored.

In any case, Catalin's ARM work is not blocked in any fashion.

Thanks,

	Ingo
