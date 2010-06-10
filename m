Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab0FJOrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:47:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40275 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758911Ab0FJOrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:47:32 -0400
Date: Thu, 10 Jun 2010 10:47:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Neil Brown <neilb@suse.de>, Felipe Contreras <felipe.contreras@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, <david@lang.hm>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, <tytso@mit.edu>,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: <201006101059.44411.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006101043510.1702-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010, Rafael J. Wysocki wrote:

> Moreover, having thought a bit more about the "power manager in user space"
> concept I'm not sure if it really is that better than the original wakelocks
> idea.  Namely, it only repaces a kernel-based mechanism with a user space
> task doing basically the same thing, but the communication between that task
> and the other cooperating user space tasks is arguably more complicated (it
> also uses the kernel resources, although indirectly).

That is all true.  The "power manager in userspace" was meant to prove
a point: that this _could_ be done without invasive changes to the
kernel.  It wasn't necessarily meant to be a _better_ solution.

> So, for a phone-like system, where you'd generally want to simplify user space,
> having a "power manager" in the kernel seems to make sense to me.

This is a judgment call.  Obviously different people have different 
opinions.

Alan Stern

