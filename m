Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab0GMQvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 12:51:11 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:58336 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754366Ab0GMQvJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 12:51:09 -0400
X-AuditID: 12074425-b7b12ae0000009fd-80-4c3c9976ee56
Subject: Re: stable? quality assurance?
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <4C3B3B39.2000809@davidnewall.com>
Date: Tue, 13 Jul 2010 12:50:47 -0400
Cc: Marcin Letyns <mletyns@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <4735EF77-6C7D-46D6-8C2B-C910A2D662D2@mit.edu>
References: <201007110918.42120.Martin@lichtvoll.de>	<20100711131640.GA3503@thunk.org>	<4C3ABA35.7020507@davidnewall.com> <AANLkTilGjfx9sb66qVfZn1SeFPURHUrrdE7JCrild8VX@mail.gmail.com> <4C3B3B39.2000809@davidnewall.com>
To: David Newall <davidn@davidnewall.com>
X-Mailer: Apple Mail (2.1081)
X-Brightmail-Tracker: AAAAARUTHCs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 12, 2010, at 11:56 AM, David Newall wrote:

> Thus 2.6.34 is the latest gamma-test kernel.  It's not stable and I doubt anybody honestly thinks otherwise.

Stable is relative.  Some people are willing to consider 
Fedora "stable".  Other people will only use a RHEL 
kernel, and there are those who are using RHEL 4 
or even RHEL 3 because they are extremely risk-adverse.

So arguments about whether or not a specific kernel 
version deserves to be called "stable" is going to be 
a waste of time and electrons because it's all about 
expectations.

But the one huge thing that people are forgetting is that
the fundamental premise behind open source is "scratch
your own itch".    That means that people who own a 
specific piece of hardware have to collectively be responsible
for making sure that it works.   It's not possible for me to
assure that some eSATA PCMCIA card on a T23 laptop
still works, because I don't own the hardware.   So the only
way we know whether or not there is a regression is 
there is *someone* who owns that hardware which is
willing to try it out, hopefully during -rc3 or -rc4, and let
us known if there is a problem, and hopefully help us
debug the problem.

If you have people saying, "-rc3 isn't stable", I'll wait until
"-rc5" to test things, then it will be that much later before
we discover a potential problem with the T23 laptop, and 
before we can fix it.   If people say, "2.6.34.0" isn't stable,
I refuse to run a kernel until "2.6.34.4", then if they are the 
only person with the T23 eSata device, then we won't hear
about the problem until 2.6.34.4, and it might not get fixed
until 2.6.34.5 or 2.6.34.6!

What this means is yes that stable basically means, "stable
for the core kernel developers".   You can say that this isn't
correct, and maybe even dishonest, but if we wait until 2.6.34.N
before we call a release "stable", and this discourages users
from testing 2.6.34.M for M<N, it just delays when bugs will
be found and fixed.

This is why to me, arguing that 2.6.34.0 is not "stable" really
isn't useful.   If you really want to frequently update your kernel
and use the latest and greatest, part of the price that you have
to pay is to help us with the testing, bug reporting, and root
cause determination.

If you don't like this, your other choice is to pay $$$ to the
folks who provide support for Solaris and OS X, and accept
the restrictions in hardware implied by Solaris and OS X.
(Hint: neither supports a Thinkpad T23.)   But to compare
Linux, especially the non-distribution source code distribution
from kernel.org with operating systems that have very different
business models is to really and fundamentally understand
how things work in the Linux world.

If you want that kind of stability, then you will need to use an
older kernel.  Or use a distribution kernel which has a support
and testing and business model compatible with your desires.
Fedora for example uses kernels which are six months out of 
date, because during those six months, the people who use the
testing versions of Fedora are doing testing and helping with
the bug fixing.   Red Hat uses this free testing pool to improve
the testing and stability of Red Hat Enterprise Linux, so if you 
are willing to live with a 2-3 year release cycle, RHEL will be 
more stable than Fedora.  And if you need to make sure that
bugs are fixed very quickly, and you can call and demand 
a developer's attention, you can pay $$$ for a support contract.

I will say once again.   There is no such thing as a free lunch.
Linux is a better deal than most, and you have multiple
choices about how frequently you update, whether you let
someone else decide whether or not a particular kernel
release plus patches is "stable", or more accurately,
"stable enough", and you can choose how much you are willing
to pay, either in personal time and effort, or $$$ to some support
organization.

But demanding that kernel.org become "more stable" when it
is supported by purely volunteers is simply not reasonable.

-- Ted

