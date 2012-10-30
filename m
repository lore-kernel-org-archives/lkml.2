Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030Ab2J3Qab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:30:31 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:36529 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531Ab2J3Qa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:30:27 -0400
Date: Tue, 30 Oct 2012 09:30:22 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Lord <kernel@teksavvy.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Ben Hutchings <ben@decadent.org.uk>,
        Yinghai Lu <yinghai@kernel.org>, Willy Tarreau <w@1wt.eu>,
        stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: Regression from 3.4.9 to 3.4.16 "stable" kernel
Message-ID: <20121030163022.GA16449@kroah.com>
References: <508E002B.4090200@teksavvy.com>
 <20121029064643.GE574@1wt.eu>
 <508E913D.2080104@teksavvy.com>
 <1351521658.13356.7.camel@deadeye.wl.decadent.org.uk>
 <20121029144722.GA23217@jshin-Toonie>
 <20121029165823.GA6614@kroah.com>
 <508F0AA6.6010702@teksavvy.com>
 <20121029230337.GA22444@kroah.com>
 <508F5D32.3080308@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508F5D32.3080308@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 12:53:06AM -0400, Mark Lord wrote:
> On 12-10-29 07:03 PM, Greg Kroah-Hartman wrote:
> > On Mon, Oct 29, 2012 at 07:00:54PM -0400, Mark Lord wrote:
> >> There's something else very wrong when going from 3.4.9 to 3.4.16.
> >> I've done it on two machines here, one the AMD-450 server (64-bit),
> >> and the other my main notebook (Core2duo 32-bit-PAE).
> >>
> >> Both systems feel much more sluggish than usual with 3.4.16 running.
> >> Reverted them both back to earlier kernels (3.4.9, 3.4.4-PAE),
> >> and the usual responsive feel has returned.
> >>
> >> Vague, I know, but something bad happened in there somewhere.
> > 
> > That's too vague for me to do anything with, sorry.  Bisection would be
> > good if you can figure out how to measure this.
> 
> Well, I'd bet Donkeys to Daises that reverting the kernel/sched.c changes
> will probably fix the responsiveness, but I haven't done that yet.
> I've lost enough time already debugging the other issues.
> 
> This is more just an indication that perhaps -stable patches need better review
> than they're getting.  Take the setup.c breakage: as soon as I pointed it out,
> a few people jumped in with knowledge that it was broken, and that patches
> existed to fix it.

There will always be bugs, fixing them quickly is the best that we can
do.

> That kind of thing should be happening before a -stable release,
> though I don't know how you would get the Right People to look
> at this stuff then rather than after the fact.  Maybe a topic
> for a future kernel summit or something.

I send patches to everyone involved, and there's a -rc period where
people are _supposed_ to test things out.  If you know of a better way
to get other people to test and review, please let me know, this is the
best that we have come up with so far.

thanks,

greg k-h
