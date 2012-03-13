Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab2CMNDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:03:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36454 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab2CMNDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:03:09 -0400
Date: Tue, 13 Mar 2012 14:02:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL/NEXT] sched/arch: Introduce the
 finish_arch_post_lock_switch() scheduler callback
Message-ID: <20120313130250.GA12248@elte.hu>
References: <20120313085628.GB6991@elte.hu>
 <20120313090040.GE27560@flint.arm.linux.org.uk>
 <20120313092649.GA15406@elte.hu>
 <20120313095020.GA13220@flint.arm.linux.org.uk>
 <20120313101859.GA2626@elte.hu>
 <20120313112729.GA25835@flint.arm.linux.org.uk>
 <20120313115640.GA27378@elte.hu>
 <20120313120014.GB13220@flint.arm.linux.org.uk>
 <20120313122053.GA17549@elte.hu>
 <20120313123634.GB2174@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313123634.GB2174@flint.arm.linux.org.uk>
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

> On Tue, Mar 13, 2012 at 01:20:53PM +0100, Ingo Molnar wrote:
> > 
> > * Russell King <rmk@arm.linux.org.uk> wrote:
> > 
> > > Why am _I_ responsible for which kernel version _Catalin_ used 
> > > for _his_ patches when _he_ committed them?
> > 
> > If you then pull that tree from him and push it out to 
> > linux-next? Then *of course* you are responsible, it was your 
> > decision to pull it.
> > 
> > I frequently reject pulls from subsystem maintainers on similar 
> > (and sometimes lesser) grounds - because such mistakes tend to 
> > compound with time.
> > 
> > The thing is, if you do Git pulls from someone then you must be 
> > absolutely anal about it, because you cannot really fix things 
> > up after the fact. The people you pull from must be your 
> > extended arms, they must be doing an equal or better job than 
> > you. That gives a basis of trust.
> > 
> > Once that is established, you can be permissive about mistakes. 
> > 
> > But arguing that you are not responsible for what you pull is 
> > absolutely grotesque and establishes a new low for this 
> > discussion really...
> > 
> > Also, as I told you in the very first mail, I am *fine* with 
> > this having happened, so you having zapped the commits is 
> > indefensible IMO. Mistakes do happen and the patch is fine 
> > technically and sfr and Linus could have handled the trivial 
> > conflict. What I suggested was to do it a bit better in the 
> > future. Is that too much to ask for?
> > 
> > > You're insane.  Totally.
> > 
> > I think you owe me an apology :-(
> 
> I owe you nothing.  From where I stand, I did nothing wrong.

Well, even ignoring the arguments you hurled several ad hominems 
at me while I wrote none.

Thanks,

	Ingo
