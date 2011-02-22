Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1BVJRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 04:17:05 -0500
Received: from www.tglx.de ([62.245.132.106]:60740 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab1BVJRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 04:17:02 -0500
Date: Tue, 22 Feb 2011 10:16:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg Ungerer <gerg@snapgear.com>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Steven King <sfking00@yahoo.com>,
        uClinux development list <uclinux-dev@uclinux.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Greg Ungerer <gregungerer@westnet.com.au>
Subject: Re: merge of m68knommu and m68k arch branches?
In-Reply-To: <4D6319E0.9080907@snapgear.com>
Message-ID: <alpine.LFD.2.00.1102221014580.2701@localhost6.localdomain6>
References: <4D5DB83D.80205@snapgear.com> <alpine.LFD.2.00.1102212216540.2701@localhost6.localdomain6> <4D6319E0.9080907@snapgear.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Tue, 22 Feb 2011, Greg Ungerer wrote:
> On 22/02/11 07:18, Thomas Gleixner wrote:
> > On Fri, 18 Feb 2011, Greg Ungerer wrote:
> > > Inside of the new arch/m68k is a little messy in the kernel and mm
> > > directories. There is plenty of scope for cleanup and merge on the
> > > files in here - but I want to leave that for follow up patches after
> > > this initial directory merge. As a data point, when we merged the
> > > m68k and m68knommu include files we had something like 70 or 80
> > > duplicate but separate files, after some cleanups that is now down to
> > > 10. Ongoing cleanup will merge some of these remaining ones as well.
> > > 
> > > Thoughts?
> > 
> > Hmm, how are you going to deal with the fact, that m68knommu uses
> > genirq, m68k not? I guess there are some more points like this
> > (clockevents, clocksource ...)
> 
> Initially it has no impact. This first step pretty much just
> combines the 2 directories, it doesn't attempt to do a fine
> grained merge of each file. (It does factor out identical
> files - quite a few in arch/m68k/lib for example).

Ah, ok. So you doing it similar to the plain move approach which we
did with x86 back then.
 
> > Is there a plan to move m68k to the generic facilities as well ?
> 
> I'll look at doing what I can as I work through merging all the
> underlying pieces :-)

Fair enough.

Thanks,

	tglx
