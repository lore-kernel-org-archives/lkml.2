Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2HBHpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 03:45:25 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44947 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2HBHpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 03:45:23 -0400
Date: Thu, 2 Aug 2012 08:45:18 +0100
From: Lee Jones <ljkenny@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org,
        linus.walleij@stericsson.com, arnd@arndb.de, olalilja@yahoo.se,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        lrg@ti.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 1/6] ASoC: dapm: If one widget fails, do not
 force all subsequent widgets to fail too
Message-ID: <20120802074517.GA19231@gmail.com>
References: <20120731142820.GW4468@opensource.wolfsonmicro.com>
 <5017EDCA.4020601@linaro.org>
 <20120731145443.GY4468@opensource.wolfsonmicro.com>
 <5017F68B.3060400@linaro.org>
 <20120731151819.GC4468@opensource.wolfsonmicro.com>
 <5018D880.5090306@linaro.org>
 <20120801132022.GS11892@opensource.wolfsonmicro.com>
 <50193428.5000708@linaro.org>
 <20120801160824.GB11892@opensource.wolfsonmicro.com>
 <20120801194134.GA4103@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120801194134.GA4103@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 08:41:34PM +0100, Mark Brown wrote:
> On Wed, Aug 01, 2012 at 05:08:24PM +0100, Mark Brown wrote:
> > On Wed, Aug 01, 2012 at 02:50:32PM +0100, Lee Jones wrote:
> 
> > > >It's very disappointing to see such an error exist, and even more
> > > >disappointing that there's no interest in fixing the driver.
> 
> > > This is incorrect. I'm sure the driver will be fixed post-haste when
> > > Ola returns back from vacation. If I can find some time I might
> > > dabble in the mean-time also.
> 
> > It may not be what you're intending but it's unfortuantely what's I'm
> > seeing.
> 
> Just to expand on this a bit since I've found myself pushing back in
> this sort of way far too often with these recent serieses and it's
> making everyone grumpy:
> 
> What I'm seeing here is a lot of patches getting sent with problems that
> I'd really not expect from someone sending such a high volume of
> patches.  Things like the lack of documentation for the DT bindings for
> example, it's something that's mandatory and which people doing lots of
> device tree work really ought to be aware of.  There's also noticable
> pushback with fixing some of these issues, and like I say this happens
> often enough to be really noticeable.
> 
> This isn't awesome from a review point of view, it's not nice to find
> issues in things and when it happens a lot for the wrong sort of thing
> it ends up seeming like the time spent doing the reviews isn't valued.

Okay, seeing as we're lying our cards on the table, here's my hand:

I'm in a very difficult position here. My initial task was to enable
Device Tree on all drivers associated with the Snowball low-cost 
development board. I was working very closely with Arnd, who was regularly
requesting code restructuring, both within the drivers and in platform
code. Something I was only too pleased to do. Then some of the original
authors noticed the restructuring and I subsequently spent a great deal of
time defending my actions. Now we have some systems in place to keep
everyone informed and happy.

Over time, the requests for Maintainers have Snowballed (pun intended). My 
task now seems to be enabling drivers for Device Tree _and_ fix all 
associated driver bugs, including any requested restructuring and API
adoption. What you fail to notice is that I am only one person, and hopping
all over the code-base trying to do everyone's bidding is no mean feat. In
reality I am no more obliged to fix driver bugs than you are. In fact as
the Maintainer of some of these subsystems, perhaps you could even help out
a bit?

With regards to the documentation, I am perfectly aware that any new binding
needs to be documented. Leaving it out was intentional until we can agree on
the bindings. After you told me you review the documentation rather than
the code bindings themselves ( pffft... ;) ) I added the documentation to
the patch-set. I always had every intention of writing them!

On your last point about feeling undervalued, that's not the case at all. I
do respect your opinion and value your reviews. They are always completed
quickly and are very thorough. If I had one complaint it's that you are
_too_ stringent. Some of this stuff really doesn't matter.

We are all trying to do good things here. Please try not to be too over-
critical. We all know Mainlining is a good thing. Perhaps less people
would be so frightened of it, thus more people would do it if the reviews
weren't such a ball-ache ( for want of a better expression :) ).
