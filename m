Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab1G2RSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:18:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34149 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1G2RSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:18:22 -0400
Date: Fri, 29 Jul 2011 21:22:27 +0200
From: Luis de Bethencourt <luis@debethencourt.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>,
        Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH 2/2] docs: update the development process document.
Message-ID: <20110729192227.GA10756@atlas>
References: <CAPA4HGVYuZ3S+OxU9dXgPuqk1ERrYNshUe27M8QmN7c4+B7LAA@mail.gmail.com>
 <CAPA4HGUHLDDTtaJ28jXNtRFJ6005=ZsQJa10TpoQmV_QxhYVPA@mail.gmail.com>
 <20110724083126.29166727@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724083126.29166727@bike.lwn.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

I updated it for the post-2.6 era. It looks better now.
Feel free to change wording, phrasing or anything really.

Thanks :)
Luis

[PATCH] docs: update the development process document.

    Here's a set of changes updating Documentation/development-process.
    I have update kernel releases and numbering scheme.

Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
---
 Documentation/development-process/2.Process |   70 ++++++++++++++-------------
 1 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/Documentation/development-process/2.Process b/Documentation/development-process/2.Process
index 4823577..82b69d4 100644
--- a/Documentation/development-process/2.Process
+++ b/Documentation/development-process/2.Process
@@ -14,6 +14,8 @@ The kernel developers use a loosely time-based release process, with a new
 major kernel release happening every two or three months.  The recent
 release history looks like this:
 
+       3.0     July 22, 2011
+       2.6.39  May 18, 2011
 	2.6.38	March 14, 2011
 	2.6.37	January 4, 2011
 	2.6.36	October 20, 2010
@@ -21,11 +23,15 @@ release history looks like this:
 	2.6.34	May 15, 2010
 	2.6.33	February 24, 2010
 
-Every 2.6.x release is a major kernel release with new features, internal
-API changes, and more.  A typical 2.6 release can contain nearly 10,000
-changesets with changes to several hundred thousand lines of code.  2.6 is
-thus the leading edge of Linux kernel development; the kernel uses a
-rolling development model which is continually integrating major changes.
+After 2.6.39 Linus Torvalds decided to call the next version 3.0, using the 20th
+anniversay as an excuse. With the bump in version number, he also decided to
+switch the numbering to 3.x, instead of the previous 2.6.x.y scheme.
+
+Every release is a major kernel release with new features, internal API changes,
+and more.  A typical release can contain nearly 10,000 changesets with changes
+to several hundred thousand lines of code.  3.0 is thus the leading edge of
+Linux kernel development; the kernel uses a rolling development model which
+is continually integrating major changes.
 
 A relatively straightforward discipline is followed with regard to the
 merging of patches for each release.  At the beginning of each development
@@ -43,11 +49,10 @@ detail later on).
 
 The merge window lasts for approximately two weeks.  At the end of this
 time, Linus Torvalds will declare that the window is closed and release the
-first of the "rc" kernels.  For the kernel which is destined to be 2.6.40,
-for example, the release which happens at the end of the merge window will
-be called 2.6.40-rc1.  The -rc1 release is the signal that the time to
-merge new features has passed, and that the time to stabilize the next
-kernel has begun.
+first of the "rc" kernels.  For the kernel which is destined to be 3.1, for
+example, the release which happens at the end of the merge window will be
+called 3.1-rc1.  The -rc1 release is the signal that the time to merge new
+features has passed, and that the time to stabilize the next kernel has begun.
 
 Over the next six to ten weeks, only patches which fix problems should be
 submitted to the mainline.  On occasion a more significant change will be
@@ -62,22 +67,21 @@ add at any time).
 As fixes make their way into the mainline, the patch rate will slow over
 time.  Linus releases new -rc kernels about once a week; a normal series
 will get up to somewhere between -rc6 and -rc9 before the kernel is
-considered to be sufficiently stable and the final 2.6.x release is made.
-At that point the whole process starts over again.
+considered to be sufficiently stable and the final release is made. At that
+point the whole process starts over again.
 
-As an example, here is how the 2.6.38 development cycle went (all dates in
+As an example, here is how the 2.6.39 development cycle went (all dates in
 2011):
 
-	January 4	2.6.37 stable release
-	January 18	2.6.38-rc1, merge window closes
-	January 21	2.6.38-rc2
-	February 1	2.6.38-rc3
-	February 7	2.6.38-rc4
-	February 15	2.6.38-rc5
-	February 21	2.6.38-rc6
-	March 1		2.6.38-rc7
-	March 7		2.6.38-rc8
 	March 14	2.6.38 stable release
+	March 29	2.6.39-rc1, merge window closes
+	April 6		2.6.39-rc2
+	April 12	2.6.39-rc3
+	April 19	2.6.39-rc4
+	April 27	2.6.39-rc5
+	May 4		2.6.39-rc6
+	May 10		2.6.39-rc7
+	May 18		2.6.39 stable release
 
 How do the developers decide when to close the development cycle and create
 the stable release?  The most significant metric used is the list of
@@ -92,26 +96,26 @@ release is made.  In the real world, this kind of perfection is hard to
 achieve; there are just too many variables in a project of this size.
 There comes a point where delaying the final release just makes the problem
 worse; the pile of changes waiting for the next merge window will grow
-larger, creating even more regressions the next time around.  So most 2.6.x
-kernels go out with a handful of known regressions though, hopefully, none
-of them are serious.
+larger, creating even more regressions the next time around.  So most stable
+release kernels go out with a handful of known regressions though, hopefully,
+none of them are serious.
 
 Once a stable release is made, its ongoing maintenance is passed off to the
 "stable team," currently consisting of Greg Kroah-Hartman.  The stable team
-will release occasional updates to the stable release using the 2.6.x.y
+will release occasional updates to the stable release using the 3.x.y
 numbering scheme.  To be considered for an update release, a patch must (1)
 fix a significant bug, and (2) already be merged into the mainline for the
 next development kernel.  Kernels will typically receive stable updates for
 a little more than one development cycle past their initial release.  So,
-for example, the 2.6.36 kernel's history looked like:
+for example, the 2.6.39 kernel's history looked like:
 
-	October 10	2.6.36 stable release
-	November 22	2.6.36.1
-	December 9	2.6.36.2
-	January 7	2.6.36.3
-	February 17	2.6.36.4
+       May 18          2.6.39 stable release
+       June 3          2.6.39.1
+       June 23         2.6.39.2
+       July 9          2.6.39.3
 
-2.6.36.4 was the final stable update for the 2.6.36 release.
+2.6.39.3 was the final stable update for the 2.6.39 release, and the last
+release with the 2.6.x.y numbering scheme.
 
 Some kernels are designated "long term" kernels; they will receive support
 for a longer period.  As of this writing, the current long term kernels
-- 
1.7.6



On Sun, Jul 24, 2011 at 08:31:26AM -0600, Jonathan Corbet wrote:
> On Sun, 24 Jul 2011 12:18:09 +0200
> Luis de Bethencourt <luis@debethencourt.com> wrote:
> 
> >     Here's a set of changes updating Documentation/development-process.
> >     I have update kernel releases.
> 
> I'm not convinced that the kernel version examples need to be updated all
> that often - but I don't see that it hurts anything either.  One thing,
> though: 
> 
> > @@ -65,19 +66,18 @@ will get up to somewhere between -rc6 and -rc9
> > before the kernel is
> >  considered to be sufficiently stable and the final 2.6.x release is made.
> >  At that point the whole process starts over again.
> > 
> > -As an example, here is how the 2.6.38 development cycle went (all dates in
> > +As an example, here is how the 2.6.39 development cycle went (all dates in
> >  2011):
> 
> A more useful exercise would have been to update things for the post-2.6
> era; there will be no more "final 2.6.x" releases.  Would you be interested
> in cleaning up that kind of stuff?  Otherwise I guess I'll get to it
> eventually.
> 
> One other thing:
> 
> > -for example, the 2.6.36 kernel's history looked like:
> > +for example, the 2.6.38 kernel's history looked like:
> > 
> > -	October 10	2.6.36 stable release
> > -	November 22	2.6.36.1
> > -	December 9	2.6.36.2
> > -	January 7	2.6.36.3
> > -	February 17	2.6.36.4
> > +	March 14	2.6.38 stable release
> > +	March 23	2.6.38.1
> > +	March 27	2.6.38.2
> > +	April 14	2.6.38.3
> > +	April 21	2.6.38.4
> > +	May 2		2.6.38.5
> > +	May 9		2.6.38.6
> > +	May 21		2.6.38.7
> > +	June 3		2.6.38.8
> > 
> >  2.6.36.4 was the final stable update for the 2.6.36 release.
> 
> Here you took out the 2.6.34.x stable updates, but left that last sentence
> as a sort of dangling reference.  If we really need to pull this forward,
> let's do the whole job.
> 
> Thanks,
> 
> jon
