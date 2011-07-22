Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab1GVVJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:09:25 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:42496 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932229Ab1GVVJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:09:24 -0400
Date: Sat, 23 Jul 2011 01:08:14 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Keith Packard <keithp@keithp.com>
Cc: Pekka Enberg <penberg@kernel.org>, Chris Wilson <chris@chris-wilson.co.uk>,
        Luke-Jr <luke@dashjr.org>, intel-gfx@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Mickler <florian@mickler.org>
Subject: Re: Major 2.6.38 / 2.6.39 / 3.0 regression ignored?
Message-ID: <20110722210814.GC14453@tugrik.mns.mnsspb.ru>
References: <013811$4lfs6@fmsmga002.fm.intel.com> <201105211123.56053.luke@dashjr.org> <aefc95$1usaq@orsmga001.jf.intel.com> <20110528131920.GA10467@tugrik.mns.mnsspb.ru> <20110712171706.GA18414@tugrik.mns.mnsspb.ru> <CAOJsxLEz-fPnb9oYnLMk9UbGqgsfm-g1d2yH=TrEiEk7HvyQzA@mail.gmail.com> <20110722110806.GA29757@tugrik.mns.mnsspb.ru> <yun7h7atcty.fsf@aiko.keithp.com> <20110722202336.GA14375@tugrik.mns.mnsspb.ru> <yunsjpyrqf7.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yunsjpyrqf7.fsf@aiko.keithp.com>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 01:50:04PM -0700, Keith Packard wrote:
> On Sat, 23 Jul 2011 00:23:36 +0400, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> 
> > What kind of a workaround are you talking about?
> 
> Just reverting the commit -- that makes your machine work, even if it's
> wrong for other machines.

Yes, I could revert it. But since the driver is reasonably complex, it
is better to know what I'm doing and that the change makes sense,
especially when it's not "my machine", but lots of target boards located
all over the country.

That's why I wanted, and imho reasonably, because I did the homework,
your feedback - to be not on my own, alone.


> > Sorry, to me it all looked like "UMS is being ignored forever".
> 
> You're right, of course -- UMS is a huge wart on the kernel driver at
> this point, keeping it working while also adding new functionality
> continues to cause challenges. We tend to expect that most people will
> run reasonably contemporaneous kernel and user space code, and so three
> years after the switch, it continues to surprise us when someone
> actually tries UMS.

We are planning upgrade to KMS too. The kernel is upgraded more often
compared to userspace, because of already mentioned (thanks!) "no
regression" rule. Userspace is more complex and more work in my context,
so it is lagging, but eventually we'll get there.

So I hope some day, when everyone upgrades, UMS support could be
"cleaned up" out from the driver.


> > I'm out of office till ~ next week's tuesday, and on return I'll try
> > to test it on the hardware in question.
> 
> Let me know; I've pushed this patch to my drm-intel-fixes tree on
> kernel.org in the meantime; if it does solve the problem, I'd like to
> add your Tested-by: line.

Yes, sure, I'll let you know the results.


Thanks,
Kirill
