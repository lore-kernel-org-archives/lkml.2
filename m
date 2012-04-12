Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966073Ab2DLW0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:26:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:38988 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934122Ab2DLW0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:26:49 -0400
Date: Fri, 13 Apr 2012 00:26:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Sasikantha Babu <sasikanth.v19@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT pull] timer fixes for 3.4
In-Reply-To: <CA+55aFxg0rzpL-xCqdScxPKPMupbvteoXD1cPT-fWYpyMXoSGg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1204130022520.2542@ionos>
References: <alpine.LFD.2.02.1204130004080.2542@ionos> <CA+55aFxg0rzpL-xCqdScxPKPMupbvteoXD1cPT-fWYpyMXoSGg@mail.gmail.com>
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

> On Thu, Apr 12, 2012 at 3:06 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > The itimer removal one is not strictly a fix, but I really wanted to
> > avoid a rebase of the urgent ones.
> 
> Btw, I think that setitimer NULL pointer removal commit is crap.
> 
> If people actually do rely on the NULL pointer thing, we're not
> "scheduling it for removal". And we most *definitely* aren't
> scheduling it for removal for some short timeframe like 3.6.
> 
> That's not how ABI's work. If it has become something people rely on,
> it now *is* part of the ABI, and no amount of "violates the spec"
> matters what-so-ever.
> 
> "The spec" is paper - and worthless. What people actually *do* is all
> that matters.

I ran it through all the various (outdated) distros I have handy and
the printk didn't show once.

I tried to figure out the reason for this NULL pointer thing, but
there is no trace of it on the intarwebs at all.

Thanks,

	tglx
