Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0FGPve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 11:51:34 -0400
Received: from www.tglx.de ([62.245.132.106]:58309 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab0FGPvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 11:51:31 -0400
Date: Mon, 7 Jun 2010 17:49:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Vitaly Wool <vitalywool@gmail.com>,
       Neil Brown <neilb@suse.de>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>,
       =?ISO-8859-1?Q?Arve_Hj=EF=BF=BDnev=EF=BF=BD?= <arve@android.com>,
       Brian Swetland <swetland@google.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       James Bottomley <James.Bottomley@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] suspend blockers & Android integrationy
In-Reply-To: <Pine.LNX.4.44L0.1006071010001.1398-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.1006071748270.2933@localhost.localdomain>
References: <Pine.LNX.4.44L0.1006071010001.1398-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

On Mon, 7 Jun 2010, Alan Stern wrote:
> On Mon, 7 Jun 2010, Thomas Gleixner wrote:
> > #2 is a tad harder, as it requires to fix the trusted apps not to fire
> >    timers when there is nothing to do.
> 
> No; all you have to do is handle the trusted apps as though they were 
> untrusted -- just as in the original wakelock approach.
> 
> >    Though you can solve it with cgroups as well. The unfreeze problem
> >    for real wakeups can be solved as mhelsley pointed out somewhere
> >    else in this thread.
> > 
> > But that depends on user space changes ....
> 
> If you handle all the apps uniformly, very few userspace changes are
> needed.

Oh, I see. I misunderstood you. -ENOTENOUGHSLEEP
 
Thanks,

	Thomas
