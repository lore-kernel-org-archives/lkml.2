Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab0LCAnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 19:43:14 -0500
Received: from kroah.org ([198.145.64.141]:55833 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab0LCAnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 19:43:13 -0500
Date: Thu, 2 Dec 2010 16:42:47 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net, Andi Kleen <andi@firstfloor.org>, greg@kroah.com
Subject: Linux stable kernel release procedure changes
Message-ID: <20101203004247.GA21762@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Over 5 1/2 years ago we started the stable Linux kernel releases, and by
all merits they seem to be pretty popular.

The stable series started out as a "once the next release is out, drop
the old one and move on" type of thing.  This worked really well until I
decided to have the 2.6.16 be a "longterm" release.  Then I did the same
thing for the 2.6.27 and later the 2.6.32 release.

These longterm releases have become very popular for the distros to base
their work on, and are getting so popular, people are now asking to do
the same thing for almost all of the recent kernels.

As this is way beyond the amount of time I have to spend on this, I've
been discussing with some people how to handle this type of thing.  In
working through the issues, I've decided that a change is due.

So, it's "back to our roots" time, and I'm now only going to be doing
-stable releases for the last kernel released, with the usual one or two
release overlap with the latest release from Linus to give people a
chance to move over and have the new release stabilize a bit.

I'm doing this as it's just way too confusing to try to explain to
people exactly what kernels are being maintained longer than others, and
why they are being maintained.  Not to mention the confusion on the
kernel.org web site where it's hard to tell what kernel release is
currently being maintained or not.

I think this is a good thing and will help both the community and
developers get back on track and focusing on the latest releases and not
needlessly waste their time on years old kernels that only distros care
about.


Oh, wait, what about those older kernels that I said I would maintain
for a long time?  Don't worry, they are sticking around but they now
have a new name "longterm" to better reflect what they are.  These
kernels will have a specific maintainer, and we will show them on the
kernel.org site in some way to show what exactly is going on with them.

These longterm kernels will abide by the same stable_kernel_rules.txt
that I've been using for the older stable rules.

For now, I'll be continuing to maintain the .27 and .32 kernels as
"longterm" kernels, but will probably be handing .27 off soon, as I'm
getting tired of it and my resources are getting limited.

I already have someone lined up who wants to maintain the .35 kernel in
a longterm manner that I trust, Andi Kleen, and I'll let him write to
explain his goals for this kernel and what he's going to do.


Also, as many people have asked about this in the past, I'm now happy to
announce that the stable@kernel.org email address is now a mailing list
that anyone can subscribe to in order to see the patches that are sent
to it, if they wish to comment or maintain their own kernel tree.  I
will warn you, it's pretty boring, and high volume at times, but hey,
it's better to work in the open as that's how we need to operate.

You can subscribe to the list at the following link if you are so
interested:
	http://linux.kernel.org/mailman/listinfo/stable


So, that's a lot of information, but if anyone has any questions about
this please let me know.  We're still figuring out what git tree we are
going to use for the longterm patch queue(s) and where to put the
releases on the kernel.org site.  Hopefully all that will be hashed out
in the next week or so.

thanks,

greg k-h


tl;dr:
	stable kernel releases only for the last kernel version,
	longterm releases for older releases done by me and different
	people but with stable_kernel_rules.txt rules, stable@kernel.org
	mailing list is now open.
