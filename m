Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab2CMNbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:31:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53106 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab2CMNbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:31:39 -0400
Date: Tue, 13 Mar 2012 14:31:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL/NEXT] sched/arch: Introduce the
 finish_arch_post_lock_switch() scheduler callback
Message-ID: <20120313133115.GA21634@elte.hu>
References: <20120313085628.GB6991@elte.hu>
 <20120313090040.GE27560@flint.arm.linux.org.uk>
 <20120313092649.GA15406@elte.hu>
 <20120313095020.GA13220@flint.arm.linux.org.uk>
 <20120313101859.GA2626@elte.hu>
 <20120313112729.GA25835@flint.arm.linux.org.uk>
 <20120313115640.GA27378@elte.hu>
 <20120313121707.GA2174@flint.arm.linux.org.uk>
 <20120313124433.GA15333@elte.hu>
 <20120313130427.GC2174@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313130427.GC2174@flint.arm.linux.org.uk>
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


* Russell King <rmk@arm.linux.org.uk> wrote:

> > Instead you first pushed back on *me*, then you claimed that 
> > you are not responsible for what you pull, then you started 
> > zapping
> 
> No I did not.  What I said was that I'm not responsible for 
> the points at which people choose to base their patches, which 
> is something entirely different. [...]

What are you talking about?

Firstly, in general *every single bit* of what you pull, 
including the base, the patch titles, the commit logs, the 
signoff chain, etc. is all part of the picture and you 
absolutely should require your contributors and submaintainers 
to do a fine job with all that.

No ifs and whens about that - it all becomes your responsibility 
as well when you decide to pull from people.

Instead you are now teaching them the exact *opposite*: for 
example you have just declared that you don't feel responsible 
for the base kernel ...

Using a sane base is IMHO part of Git pull 101. Teaching 
contributors or submaintainers to not use too old base kernels 
(or too new ones, for example during the merge window) is an 
important part of the picture.

A basic rule for bases is to either use the previous stable 
kernel release, of if that's not possible then use the freshest 
-rc available at the time of the commit - which by my quick look 
should have been about -rc6, not -rc3.

Secondly, my other problem was that this all surfaced today, at 
-rc8 time, shortly before the merge window, a very busy period 
of time.

If this was committed a month ago, if you indeed saw the 
conflict earlier proves *more* workflow breakage IMO: you pushed 
it upstream despite being aware of it being the result of a 
slightly suboptimal base, without asking whether the scheduler 
folks are still fine with all that?

Thirdly, all this totally ignores the issue you still have not 
answered: why did you leave PeterZ public lkml question about 
this unanswered:

   http://lkml.org/lkml/2012/2/16/232

PeterZ's request to put this into a separate branch was totally 
reasonable IMHO - and could have avoided this long thread, 
amongst other things. Instead you've mixed it with other bits.

Really, my quick impression is that you should learn to push 
back downstream a bit, especially as I didn't even ask for a 
rebase, a revert or anything other drastic.

Thanks,

	Ingo
