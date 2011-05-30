Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1E3Ba7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 21:30:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920Ab1E3Ba6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 21:30:58 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 May 2011 18:30:32 -0700
Message-ID: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
Subject: Linux 3.0-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yay! Let the bikeshed painting discussions about version numbering
begin (or at least re-start).

I decided to just bite the bullet, and call the next version 3.0. It
will get released close enough to the 20-year mark, which is excuse
enough for me, although honestly, the real reason is just that I can
no longe rcomfortably count as high as 40.

The whole renumbering was discussed at last years Kernel Summit, and
there was a plan to take it up this year too. But let's face it -
what's the point of being in charge if you can't pick the bike shed
color without holding a referendum on it? So I'm just going all
alpha-male, and just renumbering it. You'll like it.

Now, my alpha-maleness sadly does not actually extend to all the
scripts and Makefile rules, so the kernel is fighting back, and is
calling itself 3.0.0-rc1. We'll have the usual 6-7 weeks to wrestle it
into submission, and get scripts etc cleaned up, and the final release
should be just "3.0". The -stable team can use the third number for
their versioning.

So what are the big changes?

NOTHING. Absolutely nothing. Sure, we have the usual two thirds driver
changes, and a lot of random fixes, but the point is that 3.0 is
*just* about renumbering, we are very much *not* doing a KDE-4 or a
Gnome-3 here. No breakage, no special scary new features, nothing at
all like that. We've been doing time-based releases for many years
now, this is in no way about features. If you want an excuse for the
renumbering, you really should look at the time-based one ("20 years")
instead.

So no ABI changes, no API changes, no magical new features - just
steady plodding progress. In addition to the driver changes (and the
bulk really is driver updates), we've had some nice VFS cleanups,
various VM fixes, some nice initial ARM consolidation (yay!) and in
general this is supposed to be a fairly normal release cycle. The
merge window was a few days shorter than usual, but if that ends up
meaning a smaller release and a nice stable 3.0 release, that is all
good. There's absolutely no reason to aim for the traditional ".0"
problems that so many projects have.

In fact, I think that in addition to the shorter merge window, I'm
also considering make this one of my "Linus is being a difficult
^&^hole" releases, where I really want to be pretty strict about what
I pull during the stabilization window. Part of that is that I'm going
to be traveling next week with a slow atom laptop, so you had better
convince me I *really* want to pull from you, because that thing
really is not the most impressive piece of hardware ever built. It
does the "git" workflow quite well, but let's just say that compiling
the kernel is not quite the user experience I've gotten used to.

So be nice to me, and send me only really important fixes. And let's
make sure we really make the next release not just an all new shiny
number, but a good kernel too.

Ok?

Go forth and test,

                            Linus
