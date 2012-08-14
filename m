Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab2HNWpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 18:45:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:33649 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2HNWpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 18:45:35 -0400
Date: Wed, 15 Aug 2012 00:45:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
In-Reply-To: <20120814215632.GE25632@google.com>
Message-ID: <alpine.LFD.2.02.1208150005090.32033@ionos>
References: <1344449428-24962-1-git-send-email-tj@kernel.org> <20120813233520.GG25632@google.com> <alpine.LFD.2.02.1208142055260.32033@ionos> <20120814192203.GY25632@google.com> <alpine.LFD.2.02.1208142243500.32033@ionos>
 <20120814215632.GE25632@google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

On Tue, 14 Aug 2012, Tejun Heo wrote:
> On Tue, Aug 14, 2012 at 11:03:33PM +0200, Thomas Gleixner wrote:
> > Why should -next have different rules to mainline?
> 
> It's faster paced and trees revert.  The message specifically was a

Nonsense. It's a tree which gets stuff which is cooked and not a tree
for random experimental crap. Period.

> ping for objection and I was waiting for further response and would
> have waited until early next week (and written another "applied"
> message which would be another chance to veto).  And even if that
> isn't enough for whatever reason and you or anyone else object it
> afterwards, it'll get reverted / reouted differently / whatever.
> 
> As for subsystem boundary, at least I cross them and let others cross
> if the changes aren't significant and the proposed changes are likely
> to be be used only in that tree for the devel window.  The timer
> change seems borderline to me.  It isn't trivial but doesn't seem all
> that invasive to me.

It does not matter at all whether you think it's invasive or
not. There is a reason why we have maintainers for different parts of
the kernel who are responsible for deciding what's invasive.

And we have very well worked out mechanisms regarding cross tree
changes, i.e. providing minimal trees to pull for other maintainers.

> I don't think any critical protocol is breached here.

May I recommend that you make yourself familiar with the way how this
community works?

> If you're upset about the style of the ping, I apologize.  I'll try
> to be more sensitive when pinging you.

It's not about me. You are trying to play the system.

Thanks,

	tglx


