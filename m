Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab0GKRsX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 13:48:23 -0400
Received: from THUNK.ORG ([69.25.196.29]:45726 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab0GKRsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 13:48:21 -0400
Date: Sun, 11 Jul 2010 09:16:40 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
Message-ID: <20100711131640.GA3503@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	linux-kernel@vger.kernel.org
References: <201007110918.42120.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007110918.42120.Martin@lichtvoll.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 11, 2010 at 09:18:41AM +0200, Martin Steigerwald wrote:
> 
> I still actually *use* my machines for something else than hunting patches 
> for kernel bugs and on kernel.org it is written "Latest *Stable* Kernel" 
> (accentuation from me). I know of the argument that one should use a 
> distro kernel for machines that are for production use. But frankly, does 
> that justify to deliver in advance known crap to the distributors? What 
> impact do partly grave bugs reported on bugzilla have on the release 
> decision?

So I tend to use -rc3, -rc4, and -rc5 kernels on my laptops, and when
I find bugs, I report them and I help fix them.  If more people did
that, then the 2.6.X.0 releases would be more stable.  But kernel
development is a volunteer effort, so it's up to the volunteers to
test and fix bugs during the rc4, -rc5 and -rc6 time frame.  But if
the work tails off, because the developers are busily working on new
features for the new release, then past a certain point, delaying the
release reaches a point of diminishing returns.  This is why we do
time-based releases.

It is possible to do other types of release strategies, but look at
Debian Obsolete^H^H^H^H^H^H^H^H Stable if you want to see what happens
if you insist on waiting until all release blockers are fixed (and
even with Debian, past a certain point the release engineer will still
just reclassify bugs as no longer being release blockers --- after the
stable release has slipped for months or years past the original
projected release date.)

So if you and others like you are willing to help, then the quality of
the Linux kernels can continue to improve.  But simply complaining
about it is not likely to solve things, since threating to not be
willing to upgrade kernels is generally not going to motivate many, if
not most, of the volunteers who work on stablizing the kernel.

> I am willing to risk some testing and do bug reports, but these are 
> still production machines, I do not have any spare test machines, and 
> there needs to be some balance, i.e. the kernels should basically work. 

So you want the latest and greatest new features in a brand-new kernel
release, but you're not willing to pay for test machines, and you're
not willing to pay for a distribution support...  The fact that you
are willing to do some testing is appreciated, but remember, there's
no such thing as a free lunch.  Linux may be a very good bargain (look
at how much Oracle has increased its support contracts for Solaris!),
but it's still not a free lunch.  At the end of the day, you get what
you put into it.

Best regards,

						- Ted


