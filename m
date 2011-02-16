Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1BPI0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:26:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50627 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab1BPI0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:26:19 -0500
Date: Wed, 16 Feb 2011 09:25:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, gregkh@suse.de,
        srostedt <srostedt@redhat.com>, a.p.zijlstra@chello.nl,
        ghaskins@novell.com, stable@kernel.org, stable-commits@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Patch "sched: Give CPU bound RT tasks preference" has been added
 to the 2.6.32-longterm tree
Message-ID: <20110216082559.GA16529@elte.hu>
References: <12978046423644@kroah.org>
 <1297810967.23343.122.camel@gandalf.stny.rr.com>
 <1297821667.5126.11.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297821667.5126.11.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Tue, 2011-02-15 at 18:02 -0500, Steven Rostedt wrote:
> > [ Added LKML ]
> > 
> > On Tue, 2011-02-15 at 13:17 -0800, gregkh@suse.de wrote:
> > > This is a note to let you know that I've just added the patch titled
> > > 
> > >     sched: Give CPU bound RT tasks preference
> > > 
> > > to the 2.6.32-longterm tree which can be found at:
> > >     http://www.kernel.org/git/?p=linux/kernel/git/longterm/longterm-queue-2.6.32.git;a=summary
> > > 
> > > The filename of the patch is:
> > >      0006-sched-Give-CPU-bound-RT-tasks-preference.patch
> > > and it can be found in the queue-2.6.32 subdirectory.
> > > 
> > > If you, or anyone else, feels it should not be added to the 2.6.32 longterm tree,
> > > please let <stable@kernel.org> know about it.
> > > 
> > > 
> > 
> > I don't mind this patch being added to the long term tree. But I'm
> > curious about what is the criteria for adding changes to it? This is a
> > performance improvement and not a critical bug fix.
> 
> Yes, I added it for the performance.  .32-stable is enterprise beans and
> biscuits.  Same reason I added the load balancing fixes, boxen won't
> explode without them, but load balancing performs better with them.

We try to concentrate on regression fixes though. So performance enhancements
should only be queued up if they fix problems bad enough that could rightfully
be sent to Linus in an -rc5+ timeframe as well.

This patch is borderline i guess so i have no problems with it - but we should be 
somewhat more conservative about this in the future.

Thanks,

	Ingo
