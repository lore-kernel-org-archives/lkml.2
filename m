Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab2CMMoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:44:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44476 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab2CMMox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:44:53 -0400
Date: Tue, 13 Mar 2012 13:44:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL/NEXT] sched/arch: Introduce the
 finish_arch_post_lock_switch() scheduler callback
Message-ID: <20120313124433.GA15333@elte.hu>
References: <20120313083630.GA10131@elte.hu>
 <20120313084713.GB27560@flint.arm.linux.org.uk>
 <20120313085628.GB6991@elte.hu>
 <20120313090040.GE27560@flint.arm.linux.org.uk>
 <20120313092649.GA15406@elte.hu>
 <20120313095020.GA13220@flint.arm.linux.org.uk>
 <20120313101859.GA2626@elte.hu>
 <20120313112729.GA25835@flint.arm.linux.org.uk>
 <20120313115640.GA27378@elte.hu>
 <20120313121707.GA2174@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313121707.GA2174@flint.arm.linux.org.uk>
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

> On Tue, Mar 13, 2012 at 12:56:40PM +0100, Ingo Molnar wrote:
> > Look into the fine conflict report Russell: it conflicts with 
> > *Linus's* tree, because it's based off some random 
> > barely-beyond-rc1 development window -rc3 base. Even at the 
> > commit date of Feb 27 we had a more stable base tree available - 
> > and especially when you pulled it, several weeks down the line, 
> > -rc3 was not a defensible base for the integrated result.
> 
> I'm not going to ask someone to rebase their patches after 
> they've been fully tested on a set of platforms. [...]

That's a new argument which might be a valid concern in general 
*if you make that decision when you pull the tree* - but you 
should admit that you werent even aware of the conflict and of 
the root cause behind it, let alone be in the position to 
consider whether a rebase is justified in that case ...

( Paradoxially, rebasing is exactly what *you* ended up forcing
  others to do. I have not asked you or Catalin to rebase any
  existing commit. I merely asked about future plans. )

So I think you are just making this up on the fly. Really, if I 
push back on you in a 100% *permissive* fashion, and if my 
complaint is justified, then the proper response is for you to 
push back on your contributors - while we can keep all commits 
in place.

Instead you first pushed back on *me*, then you claimed that you 
are not responsible for what you pull, then you started zapping 
patches and claiming that you will never pull them again, 
blaming it all on me.

Again, a storm in a teacup IMO.

Thanks,

	Ingo
