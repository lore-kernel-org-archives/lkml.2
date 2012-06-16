Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab2FPKuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 06:50:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:44153 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab2FPKuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 06:50:11 -0400
Date: Sat, 16 Jun 2012 12:50:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <greg@kroah.com>
cc: ksummit-2012-discuss@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the
 question!
In-Reply-To: <20120615233413.GB8894@kroah.com>
Message-ID: <alpine.LFD.2.02.1206161103320.3086@ionos>
References: <alpine.LFD.2.02.1206152313310.3086@ionos> <20120615233413.GB8894@kroah.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2012, Greg KH wrote:
> On Sat, Jun 16, 2012 at 12:56:36AM +0200, Thomas Gleixner wrote:
> > So the main questions I want to raise on Kernel Summit are:
> > 
> >    - How do we cope with the need to review the increasing amount of
> >      (insane) patches and their potential integration?
> 
> That's a very good question, and I've been wondering if someone is
> trying to flood us with crap submissions just to try to DoS us and slow
> us down.  If not, it's an interesting "attack" vector onto our
> development process that we need to be able to handle better.

I don't think it's a DoS attack.

Interestingly enough the embedded folks have pretty much got their
gear together and are activly working on consolidation. They learned
the hard way that just hacking more crap into the code is going to end
in a disaster so they are activly watching out for other people
working in the same area.

The folks who concern me more are in the enterprise space. There are
moments where I start to believe that big corp managers have
established a secret project to implement RFC2795.

While the embedded horror is and was mostly confined in SoC specific
places, the enterprise flood is massivly targeted at the guts of the
core kernel. That makes me increasingly nervous.

> >    - How do we prevent further insanity to known problem spaces (like
> >      cpu hotplug) without stopping progress?
> 
> Progress can slow, if we want it to, in some areas, just to let people
> get the time to fix up the issues we currently have.  That saves time in
> the long run, but requires that someone make it very clear as to what is
> going on and how it will change in the future.

Indeed, but sadly there are not enough maintainers who enforce that
and trying to enforce it is a major challenge.
 
Even if people realize that there is a problem, the "we need to reach
our milestones" mindset doesn't allow them to sit down and help with
fixing it. Though that's not a Linux specific issue, but I wish that
we as the kernel community could find a way to confine this global
braindamage.

I've been doing continous cleanup work in the last decade and enjoyed
it, though I'm starting to get increasingly frustrated and grumpy. It
might be an age thing :) Though talking to Al Viro makes me certain,
that it's not.

A good start would be if you could convert your kernel statistics into
accounting the consolidation effects of contributions instead of
fostering the idiocy that corporates have started to measure themself
and the performance of their employees (I'm not kidding, it's the sad
reality) with line and commit count statistics.

Maybe that would give more people an incentive to care about the big
and long term picture instead of basking in their short sighted "hack
it into submisson" achievements. I know that it's the wrong reason
when they don't realize the real thing themself, but the end justifies
the means :)

Thanks,

	tglx
