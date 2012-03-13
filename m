Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab2CML17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 07:27:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35536 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab2CML15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 07:27:57 -0400
Date: Tue, 13 Mar 2012 11:27:29 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL/NEXT] sched/arch: Introduce the
	finish_arch_post_lock_switch() scheduler callback
Message-ID: <20120313112729.GA25835@flint.arm.linux.org.uk>
References: <20120313110840.7b444deb6b1bb902c15f3cdf@canb.auug.org.au> <20120313061622.GA24357@elte.hu> <20120313083310.GA27560@flint.arm.linux.org.uk> <20120313083630.GA10131@elte.hu> <20120313084713.GB27560@flint.arm.linux.org.uk> <20120313085628.GB6991@elte.hu> <20120313090040.GE27560@flint.arm.linux.org.uk> <20120313092649.GA15406@elte.hu> <20120313095020.GA13220@flint.arm.linux.org.uk> <20120313101859.GA2626@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313101859.GA2626@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 11:19:00AM +0100, Ingo Molnar wrote:
> 
> * Russell King <rmk@arm.linux.org.uk> wrote:
> 
> > On Tue, Mar 13, 2012 at 10:26:49AM +0100, Ingo Molnar wrote:
> > >
> > > As I said it in my first mail, doing that is unnecessary - 
> > > but if you insist on being difficult then Catalin, feel free 
> > > to pull the patch from tip:sched/arch:
> > 
> > Nope, I'm not taking the tree anymore, [...]
> 
> So instead of saying "sure, lets avoid conflicts next time 
> around" you are now *refusing* to take technically perfectly 
> fine patches just because another maintainer asked you to use a 
> different workflow for future patches? Wow ...

No, I'm pissed off at how you're treating me over this trivial issue,
so I'm taking the easy way out and getting out of the way.  If you want
to run your bit of the tree with idiotic rules about zero conflicts,
and "git solutions" then that's your perogative.  Just don't expect
other people to play with you.

The fact of the matter is that Peter Z. was fully aware of what was
happening.  He was aware that he'd been asked for his ack for that
patch (because I'd explicitly asked Peter for it, but not by email) -
and he provided his ack for that patch to Catalin:

http://lists.arm.linux.org.uk/lurker/message/20120227.144813.5614e7f8.en.html

Catalin sent a pull request to me, copying Peter Z on the 27th Feb:

http://lists.arm.linux.org.uk/lurker/message/20120227.164502.6b58a37e.en.html

I pulled it into my tree for testing, and pushed it out in the last
couple of days.

Moreover, these kinds of trivial conflicts are the type of things which
Linus wants to see between trees.  It allows him to get a feel for what's
going on, and makes Linus feel like he's more on top of things.  Linus
said that he would like to see these trivial conflicts (he said so to me
in an email dated 15th Jan 2011).

So please, stop your insistance on this zero conflict crap.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
