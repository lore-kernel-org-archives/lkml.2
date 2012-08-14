Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab2HNXBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:01:07 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:41606 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2HNXBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:01:06 -0400
Date: Tue, 14 Aug 2012 16:01:00 -0700
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
Message-ID: <20120814230100.GF25632@google.com>
References: <1344449428-24962-1-git-send-email-tj@kernel.org>
 <20120813233520.GG25632@google.com>
 <alpine.LFD.2.02.1208142055260.32033@ionos>
 <20120814192203.GY25632@google.com>
 <alpine.LFD.2.02.1208142243500.32033@ionos>
 <20120814215632.GE25632@google.com>
 <alpine.LFD.2.02.1208150005090.32033@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1208150005090.32033@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas.

On Wed, Aug 15, 2012 at 12:45:24AM +0200, Thomas Gleixner wrote:
> And we have very well worked out mechanisms regarding cross tree
> changes, i.e. providing minimal trees to pull for other maintainers.

If you look at the review branches, they're actually structured that
way so that the timer part can be pulled separately.  If the
maintainer wants to do that, sure.  If the maintainer thinks routing
through another tree is fine, that's okay too.  Subsystem boundaries
are all good and great but it's not some absolute barrier which can't
be crossed at any cost.

> > If you're upset about the style of the ping, I apologize.  I'll try
> > to be more sensitive when pinging you.
> 
> It's not about me. You are trying to play the system.

Thomas, I wasn't trying to get it through behind your back.  You have
been notified clearly multiple times and have ample opportunities to
object and suggest different ways if you don't like whatever is going
on.

I probably should have written "if the maintainer doesn't object, I
think it would be easier to route these through wq/for-3.7 as it will
be the only user for now, blah blah blah" instead and maybe I
misjudged the character of the changes or the subsystem.  That said, I
think you're inferring too much.

Thanks.

-- 
tejun
