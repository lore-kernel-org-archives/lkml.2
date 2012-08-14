Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab2HNXdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:33:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:33844 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab2HNXdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:33:14 -0400
Date: Wed, 15 Aug 2012 01:33:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
In-Reply-To: <20120814230100.GF25632@google.com>
Message-ID: <alpine.LFD.2.02.1208150116570.32033@ionos>
References: <1344449428-24962-1-git-send-email-tj@kernel.org> <20120813233520.GG25632@google.com> <alpine.LFD.2.02.1208142055260.32033@ionos> <20120814192203.GY25632@google.com> <alpine.LFD.2.02.1208142243500.32033@ionos> <20120814215632.GE25632@google.com>
 <alpine.LFD.2.02.1208150005090.32033@ionos> <20120814230100.GF25632@google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012, Tejun Heo wrote:
> On Wed, Aug 15, 2012 at 12:45:24AM +0200, Thomas Gleixner wrote:
> > And we have very well worked out mechanisms regarding cross tree
> > changes, i.e. providing minimal trees to pull for other maintainers.
> 
> If you look at the review branches, they're actually structured that
> way so that the timer part can be pulled separately.  If the
> maintainer wants to do that, sure.  If the maintainer thinks routing
> through another tree is fine, that's okay too.  Subsystem boundaries
> are all good and great but it's not some absolute barrier which can't
> be crossed at any cost.

That's not about any cost. You are trying to force stuff into -next
with a THREE workdays notice, just because you think that your stuff
is so important.

Have you ever tried to understand how the kernel development system
works?

> I probably should have written "if the maintainer doesn't object, I
> think it would be easier to route these through wq/for-3.7 as it will
> be the only user for now, blah blah blah" instead and maybe I
> misjudged the character of the changes or the subsystem.  That said, I
> think you're inferring too much.

No, I'm, not inferrring too much. It's not about what you should have
written.

It's about your general attitude. You really think that I accept all
that stuff just because you add some "blah, blah, blah" to some mail?

Far from it!

To convince me to accept your patches you should start answering my
questions and suggestions seriously in the first place and not
discarding them upfront as lunatic visions.

As long as you can't provide a proper counter argument against
maintaining the timer in the same context as the work, no matter what
the underlying mechanism to achieve this will be, I'm not going to
accept any of this hackery neither near next nor mainline.

Thanks,

	tglx
