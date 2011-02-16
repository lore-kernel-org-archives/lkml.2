Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab1BPCBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:01:18 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:58651 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758642Ab1BPCBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 21:01:14 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/3fvIkfe33spKUMWRifYl0QZ95nBdXDFewi8tuFB
	Dn6BVu+tn4ZW2k
Subject: Re: Patch "sched: Give CPU bound RT tasks preference" has been
 added to the 2.6.32-longterm tree
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: gregkh@suse.de, srostedt <srostedt@redhat.com>, a.p.zijlstra@chello.nl,
        ghaskins@novell.com, mingo@elte.hu, stable@kernel.org,
        stable-commits@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1297810967.23343.122.camel@gandalf.stny.rr.com>
References: <12978046423644@kroah.org>
	 <1297810967.23343.122.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 03:01:07 +0100
Message-ID: <1297821667.5126.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 18:02 -0500, Steven Rostedt wrote:
> [ Added LKML ]
> 
> On Tue, 2011-02-15 at 13:17 -0800, gregkh@suse.de wrote:
> > This is a note to let you know that I've just added the patch titled
> > 
> >     sched: Give CPU bound RT tasks preference
> > 
> > to the 2.6.32-longterm tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/longterm/longterm-queue-2.6.32.git;a=summary
> > 
> > The filename of the patch is:
> >      0006-sched-Give-CPU-bound-RT-tasks-preference.patch
> > and it can be found in the queue-2.6.32 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the 2.6.32 longterm tree,
> > please let <stable@kernel.org> know about it.
> > 
> > 
> 
> I don't mind this patch being added to the long term tree. But I'm
> curious about what is the criteria for adding changes to it? This is a
> performance improvement and not a critical bug fix.

Yes, I added it for the performance.  .32-stable is enterprise beans and
biscuits.  Same reason I added the load balancing fixes, boxen won't
explode without them, but load balancing performs better with them.

	-Mike



