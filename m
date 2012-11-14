Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab2KNHYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:24:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab2KNHYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:24:09 -0500
Date: Tue, 13 Nov 2012 23:24:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hughd@google.com>
Subject: Re: linux-next: Tree for Nov 14
Message-Id: <20121113232405.7dd4fe03.akpm@linux-foundation.org>
In-Reply-To: <20121114181536.3ec35e5ec622e7eaec791e00@canb.auug.org.au>
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
	<20121113213742.292f3ace.akpm@linux-foundation.org>
	<20121114064726.GA2537@gmail.com>
	<20121113225635.a848fd6c.akpm@linux-foundation.org>
	<20121114181536.3ec35e5ec622e7eaec791e00@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012 18:15:36 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Tue, 13 Nov 2012 22:56:35 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Wed, 14 Nov 2012 07:47:26 +0100 Ingo Molnar <mingo@kernel.org> wrote:
> > 
> > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > It would help if the old sched/numa code wasn't in -next while 
> > > > you're away.  That would give me a clean run at 3.7 and will 
> > > > make it easier for others to integrate and test the four(!) 
> > > > different autoschednumacore implementations on top of 
> > > > linux-next.
> > > > 
> > > > Pretty please?
> > > 
> > > The next integration should have this solved: I have removed the 
> > > old sched/numa bits, replaced by the latest rebased/reworked 
> > > numa/core bits.
> > 
> > That solves one problem, but I still need to route around the numa
> > stuff when preparing the 3.8-rc1 merge.  Again!
> 
> I am not sure what is actually involved here, but would it help if I
> made you a new akpm-base with the old tip tree replaced by the new one
> that Ingo just pushed out?  Or are there still problematic things in the
> tip tree?

If this new code is targeted at 3.9 as I'm suggesting then it should go
into -next after 3.8-rc1, so the sched/numa part of -tip should be
omitted from -next until then.

If instead the plan is to merge it all into 3.8 then -tip should go
into -next as-is.

How's your crystal ball?
