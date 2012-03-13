Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab2CMNEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:04:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51804 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab2CMNEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:04:47 -0400
Date: Tue, 13 Mar 2012 13:04:27 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL/NEXT] sched/arch: Introduce the
	finish_arch_post_lock_switch() scheduler callback
Message-ID: <20120313130427.GC2174@flint.arm.linux.org.uk>
References: <20120313084713.GB27560@flint.arm.linux.org.uk> <20120313085628.GB6991@elte.hu> <20120313090040.GE27560@flint.arm.linux.org.uk> <20120313092649.GA15406@elte.hu> <20120313095020.GA13220@flint.arm.linux.org.uk> <20120313101859.GA2626@elte.hu> <20120313112729.GA25835@flint.arm.linux.org.uk> <20120313115640.GA27378@elte.hu> <20120313121707.GA2174@flint.arm.linux.org.uk> <20120313124433.GA15333@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313124433.GA15333@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 01:44:33PM +0100, Ingo Molnar wrote:
> 
> * Russell King <rmk@arm.linux.org.uk> wrote:
> 
> > On Tue, Mar 13, 2012 at 12:56:40PM +0100, Ingo Molnar wrote:
> > > Look into the fine conflict report Russell: it conflicts with 
> > > *Linus's* tree, because it's based off some random 
> > > barely-beyond-rc1 development window -rc3 base. Even at the 
> > > commit date of Feb 27 we had a more stable base tree available - 
> > > and especially when you pulled it, several weeks down the line, 
> > > -rc3 was not a defensible base for the integrated result.
> > 
> > I'm not going to ask someone to rebase their patches after 
> > they've been fully tested on a set of platforms. [...]
> 
> That's a new argument which might be a valid concern in general 
> *if you make that decision when you pull the tree* - but you 
> should admit that you werent even aware of the conflict and of 
> the root cause behind it, let alone be in the position to 
> consider whether a rebase is justified in that case ...

No Ingo.  I was aware of the conflict, because when I merged it into
my test tree, I got that conflict and fixed it up myself before I
tested the frigging thing.

> So I think you are just making this up on the fly.

If you think that, we have nothing further to discuss.  But I know
I'm right, because:

commit e3507976ee7ad0a58fa68ce919a7acfcfec28e3b
Merge: 4c17fe7 8cee1aa
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Thu Mar 8 09:51:31 2012 +0000

    Merge branch 'intr-ctxsw' of git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux

    Conflicts:
        kernel/sched/core.c

http://ftp.arm.linux.org.uk/git/?p=linux-next.git;a=commitdiff;h=e350797
(which is _not_ in a public branch, and is _only_ accessible via knowing
the commit id.)

Oh look, March 8th.  Oh, that's last Thursday.  Oh, maybe I did merge
it a while back after all, maybe I'm not making this crap up.  Maybe
I did know about the conflict but didn't think anything of it because
it was soo trivial.

> Instead you first pushed back on *me*, then you claimed that you 
> are not responsible for what you pull, then you started zapping 

No I did not.  What I said was that I'm not responsible for the points
at which people choose to base their patches, which is something entirely
different.  Unlike you, I have _no_ _problem_ with pulling work based on
_any_ -rc, or indeed any commit whatsoever - provided it's been tested
and it merges relatively cleanly with the branch I'm pulling it into.

> patches and claiming that you will never pull them again, 
> blaming it all on me.

I'm only blaming this thread on you, precisely because you're making a
mountain out of a mole hill.  There's no problem here.  Really.  At all.
You're just blowing it out of all proportion making it into some huge big
issue.  _That_ alone is the whole reason why I've dropped Catalins patches.
I don't want to be subjected to your rants over this.  Instead, _you_ can
deal with this patch set and deal with the other conflicts which git can
resolve automatically.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
