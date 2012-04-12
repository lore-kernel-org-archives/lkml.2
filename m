Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762933Ab2DLWjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:39:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:39020 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790Ab2DLWjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:39:45 -0400
Date: Fri, 13 Apr 2012 00:39:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Sasikantha Babu <sasikanth.v19@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT pull] timer fixes for 3.4
In-Reply-To: <CA+55aFzP-DmGUqGcnxj2mq-mvmOXA7k-zgOrdDRY3WA9N5dmBg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1204130037060.2542@ionos>
References: <alpine.LFD.2.02.1204130004080.2542@ionos> <CA+55aFxg0rzpL-xCqdScxPKPMupbvteoXD1cPT-fWYpyMXoSGg@mail.gmail.com> <alpine.LFD.2.02.1204130022520.2542@ionos> <CA+55aFzP-DmGUqGcnxj2mq-mvmOXA7k-zgOrdDRY3WA9N5dmBg@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012, Linus Torvalds wrote:

> On Thu, Apr 12, 2012 at 3:26 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > I ran it through all the various (outdated) distros I have handy and
> > the printk didn't show once.
> >
> > I tried to figure out the reason for this NULL pointer thing, but
> > there is no trace of it on the intarwebs at all.
> 
> Ok. If we don't see any reports of messages, we can certainly remove it.
> 
> That said, would people actually *report* those messages?
> 
> In general, for things like this, it's probably better to just make
> the change (especially if you have several distros you can test), and
> then add a printk_once() for the case that changed. Then, if people

I changed it to a printk_once() already.

> actually report it as some program stopping to work, the dmesg
> hopefully clues us in about the reason for the program not working.
> But that would have needed to happen during the merge window, it's too
> late now.

Yeah, sorry. I queued it and missed to send it along in time, then
queued other real fixes on top of it. Feel free to revert it and i put
it up for 3.5

Thanks,

	tglx
