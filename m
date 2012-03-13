Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab2CMLMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 07:12:06 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48180 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613Ab2CMLMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 07:12:05 -0400
Date: Tue, 13 Mar 2012 11:11:26 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Russell King <rmk@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL/NEXT] sched/arch: Introduce the
 finish_arch_post_lock_switch() scheduler callback
Message-ID: <20120313111126.GC26370@arm.com>
References: <20120313110840.7b444deb6b1bb902c15f3cdf@canb.auug.org.au>
 <20120313061622.GA24357@elte.hu>
 <20120313083310.GA27560@flint.arm.linux.org.uk>
 <20120313083630.GA10131@elte.hu>
 <20120313084713.GB27560@flint.arm.linux.org.uk>
 <20120313085628.GB6991@elte.hu>
 <20120313090040.GE27560@flint.arm.linux.org.uk>
 <20120313092649.GA15406@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313092649.GA15406@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue, Mar 13, 2012 at 09:26:49AM +0000, Ingo Molnar wrote:
> As I said it in my first mail, doing that is unnecessary - but 
> if you insist on being difficult then Catalin, feel free to pull 
> the patch from tip:sched/arch:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/arch
> 
>    HEAD: 01f23e1630 sched/arch: Introduce the finish_arch_post_lock_switch() scheduler callback
> 
> it's v3.3-rc7 based so it will generate no conflict with 
> linux-next. It only contains this commit so you can use it 
> without pulling in other pending scheduler changes.

Thanks for merging the scheduler hook.

So I'll send Russell another pull request after the 3.4-rc1, containing
only ARM patches. The only drawback is that the removal of
__ARCH_WANT_INTERRUPTS_ON_CTXSW will have to wait another release cycle.

-- 
Catalin
