Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab2GNJau (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 05:30:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58440 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab2GNJas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 05:30:48 -0400
Date: Sat, 14 Jul 2012 11:30:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120714093032.GA23316@elf.ucw.cz>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
 <201207071927.13135.arnd@arndb.de>
 <20120710071023.GA10456@gmail.com>
 <20120710101018.GE15120@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120710101018.GE15120@arm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > With the risk of bikeshedding here, but I find the name awkward. How
> > > > about just naming the arch port arm64 instead? It's considerably more
> > > > descriptive in the context of the kernel.  For reference, we didn't
> > > > name ppc64, nor powerpc, after what the IBM/power.org marketing people
> > > > were currently calling the architecture at the time either.
> > > 
> > > I agree the name sucks, [...]
> > 
> > So why not change it now, when it only bothers a few dozen 
> > people and it is only present in 36 patches? Why go full steam 
> > ahead to annoy thousands of people with it and why spread the 
> > naming madness to thousands of commits?
> 
> Changing the arch/ dir name is easy at this point. My preference is for
> consistency with the official name (that cannot be changed) and the gcc
> triplet. I also don't think it annoys thousands of people, most don't
> really care. The few reactions I've seen is pretty much because people
> were expecting arm64 and it came as something else.

I guess I'm 3/1000 now... Anyway, gcc triplet can be changed, and
official name does not seem to matter.

> > > Agreed. It's clear from the code that it started out as a copy 
> > > of the 32 bit ARM code base, which I think was a mistake, but 
> > > it has also moved on since then and many areas of the 64 bit 
> > > code are now much cleaner because they don't have to worry 
> > > about breaking legacy code. We're also more flexible with 
> > > trying out stuff without having to worry about breaking some 
> > > 10 year old board code.
> > 
> > Just for the record, you guys are repeating all the same 
> > arguments that led to the x86_64 fork a decade ago...
> 
> As I stated already, comparing AArch64 to x86_64 is not right. So even
> if the arguments may look the same, the context is *different*. AArch64
> is *not* an extension to the AArch32 mode.

Is it possible to boot 32-bit OS on aarch64 machine?

IOW, is it compatible in supervisor mode, too?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
