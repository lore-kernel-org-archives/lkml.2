Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab2CLLWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 07:22:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:46166 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab2CLLWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 07:22:40 -0400
Date: Mon, 12 Mar 2012 12:22:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Subject: Re: [PATCH bisected regression] sched: rebuild sched domains at
 suspend/resume
In-Reply-To: <4F5D00AE.8000602@openvz.org>
Message-ID: <alpine.LFD.2.02.1203121221130.2466@ionos>
References: <20120306204357.13169.90791.stgit@zurg> <1331067743.11248.333.camel@twins> <CA+55aFxPiW=T8iNy=Fb_fuO2DYV9+sQL-mr8=Uc7cWymTyVt6A@mail.gmail.com> <1331084302.11248.338.camel@twins> <CA+55aFx6NXjLpAz_Bu1wvaxFB-2zrYGkfBeN_8rM5q7MkYuNEQ@mail.gmail.com>
 <4F5D00AE.8000602@openvz.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2012, Konstantin Khlebnikov wrote:
> Linus Torvalds wrote:
> > On Tue, Mar 6, 2012 at 5:38 PM, Peter Zijlstra<a.p.zijlstra@chello.nl>
> > wrote:
> > > On Tue, 2012-03-06 at 16:54 -0800, Linus Torvalds wrote:
> > > > I do agree that reverting is probably safer at this point, but can we
> > > > get agreement on this?
> > > 
> > > I agree with reverting, shoot it in the head :-) Do you want a git
> > > thingy?
> > 
> > Well, it's less a "git thingy" and more that there are tons of people
> > involved with the original commit that haven't even piped up.
> > 
> > Srivatsa, Ingo, Prashanth..
> > 
> > In fact, I notice that Prashanth doesn't even seem to have been cc'd,
> > even if he's the original reporter of the commit that gets reverted.
> > Added (see lkml)
> 
> I forget to mention my kernel boot options. I live with them for a while, so I
> just forget about it.
> "debug threadirqs i915.i915_enable_rc6=1 i915.i915_enable_fbc=1
> i915.lvds_downclock=1 crashkernel=128M"
> 
> So, "threadirqs" is a lost piece of the puzzle -- without it I cannot
> reproduce the bug.
> However, I have no idea how this is connected to sched-domains. =)

To be honest, I have no idea either. Can you figure out where the box
hangs or is it in the "silent" phase of suspend/resume?

Thanks,

	tglx


