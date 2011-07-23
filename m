Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab1GWSUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 14:20:22 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:44127 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab1GWSUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 14:20:16 -0400
Date: Sat, 23 Jul 2011 22:19:01 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Keith Packard <keithp@keithp.com>, Pekka Enberg <penberg@kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>, Luke-Jr <luke@dashjr.org>,
        intel-gfx@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ray Lee <ray-lk@madrabbit.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] Major 2.6.38 / 2.6.39 / 3.0 regression ignored?
Message-ID: <20110723181901.GB16414@tugrik.mns.mnsspb.ru>
References: <20110528131920.GA10467@tugrik.mns.mnsspb.ru> <20110712171706.GA18414@tugrik.mns.mnsspb.ru> <CAOJsxLEz-fPnb9oYnLMk9UbGqgsfm-g1d2yH=TrEiEk7HvyQzA@mail.gmail.com> <20110722110806.GA29757@tugrik.mns.mnsspb.ru> <yun7h7atcty.fsf@aiko.keithp.com> <20110722202336.GA14375@tugrik.mns.mnsspb.ru> <yunsjpyrqf7.fsf@aiko.keithp.com> <20110722210814.GC14453@tugrik.mns.mnsspb.ru> <20110722213102.GA14749@tugrik.mns.mnsspb.ru> <CADnq5_NG4eZ0nc-Xk+hvpaMhLz18=W3V7+AWxf+_s8GXpZmwmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADnq5_NG4eZ0nc-Xk+hvpaMhLz18=W3V7+AWxf+_s8GXpZmwmg@mail.gmail.com>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 11:10:53AM -0400, Alex Deucher wrote:
> On Fri, Jul 22, 2011 at 5:31 PM, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> > On Sat, Jul 23, 2011 at 01:08:14AM +0400, Kirill Smelkov wrote:
> >> On Fri, Jul 22, 2011 at 01:50:04PM -0700, Keith Packard wrote:
> >
> >> > You're right, of course -- UMS is a huge wart on the kernel driver at
> >> > this point, keeping it working while also adding new functionality
> >> > continues to cause challenges. We tend to expect that most people will
> >> > run reasonably contemporaneous kernel and user space code, and so three
> >> > years after the switch, it continues to surprise us when someone
> >> > actually tries UMS.
> >>
> >> We are planning upgrade to KMS too. The kernel is upgraded more often
> >> compared to userspace, because of already mentioned (thanks!) "no
> >> regression" rule. Userspace is more complex and more work in my context,
> >> so it is lagging, but eventually we'll get there.
> >
> > Also wanted to say, that if whole X could be built, like the kernel, from one
> > repo without multirepo-setup tool, with 100% reliable working
> > incremental rebuild, etc... it would be a bit easier to upgrade X too.
> >
> > Sorry for being a bit offtopic, could not resist. I was keeping that
> > though in my head for ~ 2 years already, and now had a chance to mention it.
> 
> You don't have to rebuild all of X to use KMS.  In most cases, you
> just need to update the ddx for your card.

I meant the rebuilt not to use KMS, but general case. To me the kernel
has one of the great advantage of being lots of self-consistent code
because of being maintained in one repo + good build system + good
development process. And as the result it is (relatively) easy to
upgrade.

Anyway, this is just a note from both kernel and X stranger, so
whatever...


Kirill
