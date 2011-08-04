Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab1HDFD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 01:03:58 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:34026 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab1HDFDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 01:03:51 -0400
Date: Thu, 04 Aug 2011 01:03:40 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [GIT PULL] idle patches for Linux 3.1
In-reply-to: <CA+55aFxikiro4cEwGEOMCGUswyPsaAwyspP1cFUviJ5OUKOZJw@mail.gmail.com>
Message-id: <alpine.LFD.2.02.1108040030550.29492@x980>
References: <alpine.LFD.2.02.1108031627060.19398@x980>
 <CA+55aFxikiro4cEwGEOMCGUswyPsaAwyspP1cFUviJ5OUKOZJw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Aug 3, 2011 at 10:54 AM, Len Brown <lenb@kernel.org> wrote:
> >
> > please pull from:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-release
> 
> As with the APEI tree, the commits are all recent and cannot have been
> in -next.  It's the last day before the merge window closes, please
> tell me why I should take this in this cycle at all?

I re-based this branch immediately before pushing
in order to add "Acked-by" annotations.

The cpuidle patches were in linux-next back in April.
But they were on a branch with other patches that got
deferred till 2012 b/c some folks were uneasy with
me deleting so much code so suddenly.  I cherry-picked
some simple ones here b/c IBM asked me to in order to
make their upcoming p-series cpuidle patches cleaner.

The mrst pmu.c driver is new.  MRST doesn't work without it.
Of course, if you don't have CONFIG_X86_MRST=y, you don't care.

Yes, this pull request is late, and if you skip it,
life will still go on.  You'll simply see the same
patches wating for you in 10 weeks.  On the other hand,
some developers will have a happier summer if these get upstream now,
and I'm here to support them if anything goes wrong.

thanks,
-Len

