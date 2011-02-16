Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab1BPCqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:46:39 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:53838 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752716Ab1BPCqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 21:46:37 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19h0QVjJqBhbdYz5APdE9Bsl0FinVezPY1uO0tHr+
	OdauSwp60auq57
Subject: Re: Patch "sched: Give CPU bound RT tasks preference" has been
 added to the 2.6.32-longterm tree
From: Mike Galbraith <efault@gmx.de>
To: Greg KH <gregkh@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, srostedt <srostedt@redhat.com>,
        a.p.zijlstra@chello.nl, ghaskins@novell.com, mingo@elte.hu,
        stable@kernel.org, stable-commits@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110215233210.GA3378@suse.de>
References: <12978046423644@kroah.org>
	 <1297810967.23343.122.camel@gandalf.stny.rr.com>
	 <20110215233210.GA3378@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 03:46:32 +0100
Message-ID: <1297824392.5126.52.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 15:32 -0800, Greg KH wrote:
> On Tue, Feb 15, 2011 at 06:02:47PM -0500, Steven Rostedt wrote:
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
> I'll defer to Mike here, as he submitted this series.  I'm pretty sure
> it resolves a number of problems reported with the schedular, overall,
> with the whole series, right?
> 
> Mike?

This particular patch was purely about performance.  The general thrust
of the series is of course about getting reported issues fixed.  We've
got bug reports, and I'm sure everyone else does too.

	-Mike

