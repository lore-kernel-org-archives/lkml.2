Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab2KNG4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:56:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab2KNG4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:56:39 -0500
Date: Tue, 13 Nov 2012 22:56:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hughd@google.com>
Subject: Re: linux-next: Tree for Nov 14
Message-Id: <20121113225635.a848fd6c.akpm@linux-foundation.org>
In-Reply-To: <20121114064726.GA2537@gmail.com>
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
	<20121113213742.292f3ace.akpm@linux-foundation.org>
	<20121114064726.GA2537@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012 07:47:26 +0100 Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 14 Nov 2012 16:30:42 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > News: next-20121115 (i.e. tomorrow) will be the last release until
> > > next-20121126 (which should be just be after -rc7, I guess - assuming
> > > that Linus does not release v3.7 before then), so if you want something
> > > in linux-next for a reasonable amount of testing, it should probably be
> > > committed tomorrow.
> > 
> > It would help if the old sched/numa code wasn't in -next while 
> > you're away.  That would give me a clean run at 3.7 and will 
> > make it easier for others to integrate and test the four(!) 
> > different autoschednumacore implementations on top of 
> > linux-next.
> > 
> > Pretty please?
> 
> The next integration should have this solved: I have removed the 
> old sched/numa bits, replaced by the latest rebased/reworked 
> numa/core bits.
> 

That solves one problem, but I still need to route around the numa
stuff when preparing the 3.8-rc1 merge.  Again!

And yes, I'm assuming you're not targeting 3.8.  Given the history
behind this and the number of people who are looking at it, that's too
hasty.  Hugh can speak to his own reasons for feeling the same way.

And I must say that I deeply regret not digging my heels in when this
went into -next all those months ago.  It has caused a ton of trouble
for me and for a lot of other people.

Put it in -next after 3.8-rc1 with a view to a 3.9 merge, please.
