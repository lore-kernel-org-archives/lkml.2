Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab0HQHJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:09:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:54770 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427Ab0HQHJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:09:24 -0400
Date: Tue, 17 Aug 2010 17:08:58 +1000
From: Neil Brown <neilb@suse.de>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Pavel Machek <pavel@ucw.cz>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, paulmck@linux.vnet.ibm.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, florian@mickler.org,
        rjw@sisk.pl, peterz@infradead.org, tglx@linutronix.de,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100817170858.3c3385f7@notabene>
In-Reply-To: <20100817002032.GD21182@thunk.org>
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<Pine.LNX.4.44L0.1008120733130.21006-100000@netrider.rowland.org>
	<AANLkTinMwt27wuDUh32F36wpoC54Syzp1_nK9UCxYmEK@mail.gmail.com>
	<20100812125248.GA2763@thunk.org>
	<20100814075000.GB27430@elf.ucw.cz>
	<20100816081655.3e9e29f7@virtuousgeek.org>
	<20100817002032.GD21182@thunk.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Aug 2010 20:20:32 -0400
Ted Ts'o <tytso@mit.edu> wrote:

> On Mon, Aug 16, 2010 at 08:16:55AM -0700, Jesse Barnes wrote:
> > Fortunately in this case the problem doesn't seem to be fatal.  We've
> > already established that the userland API portion of suspend blockers
> > could be implemented in userspace with a bit more work, given that the
> > kernel problems with suspend/resume and events are addressed.
> > Hopefully Google is already developing a prototype userspace
> > implementation to make sure it's workable; being able to build stock
> > upstream kernels for my Droid and its Android userspace sure would be
> > nice.
> 
> You know, you don't have to wait for the Android engineers to do this
> work.  You (or others who want to be able to use stock upstream kernel
> with Android devices) could just as easily try to do the "bit more
> work" yourselves --- that is, do the open souce thing and scratch
> one's own itch.
> 
> After all, Rafael is saying he's refusing to accept patches (or
> implement) in-kernel oppunsitic suspend for upstream unless it's
> proven to him that a userspace implementation isn't sufficient.  It
> might be just as fair for the Android userspace upstream to refuse to
> accept (or engineer) userspace changes unless it is proven that the
> userspace version of opporunistic suspend is just as good as the
> in-kernel version which is successfully been deployed in millions and
> millions of shipping units today...

Reminds me of the one of the first questions asked in a murder investigation
(or so they say on TV)
   Cui Bono??

Who benefits?  Does Android benefit more by being able to use a standard
kernel, or does Linux benefit more by being able to run Android without
modification.

Currently it seems that only the lawyers^Wpeople who like arguing on lkml are
gaining anything.

Maybe this is the first real fork of Linux - google might be rich enough to
persist with it.

> 
> Speaking personally, it's not clear to me how waking up a userspace
> suspend daemon and waiting for it to get scheduled will result in
> better power savings than simply handling it in the kernel, but as
> soon as someone is willing to do the work, we can find out for sure
> who is right.

I'm surprised at this comment Ted!
Power saving is not the single supreme goal, yet you make it sound like it is.

It should be no surprise to anyone if the most maintainable solution uses a
little more power than the most highly optimised solution.  I think most of
us would still prefer the more maintainable solution.  However, if google
sees a market opportunity for the minor optimisation of suspend-from-kernel
rather than suspend-from-user-space, then it would seem they are welcome to
it.

NeilBrown

