Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab2IRUlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:41:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35356 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab2IRUlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:41:47 -0400
Date: Tue, 18 Sep 2012 21:40:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Greg Ungerer <gerg@snapgear.com>,
        dedekind1@gmail.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>, linux-m68k@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH] clk: Make the managed clk functions generically
	available
Message-ID: <20120918204014.GY12245@n2100.arm.linux.org.uk>
References: <20120910002020.GB16249@opensource.wolfsonmicro.com> <20120910003913.GM13739@n2100.arm.linux.org.uk> <504F4E36.20309@metafoo.de> <1347375033.27206.3.camel@sauron.fi.intel.com> <504FE633.2090304@snapgear.com> <5050F3DB.1050202@metafoo.de> <20120915213151.GM12245@n2100.arm.linux.org.uk> <20120918080037.GA15982@avionic-0098.mockup.avionic-design.de> <20120918093536.GV12245@n2100.arm.linux.org.uk> <20120918112555.GA21004@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120918112555.GA21004@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 01:25:55PM +0200, Thierry Reding wrote:
> On Tue, Sep 18, 2012 at 10:35:36AM +0100, Russell King - ARM Linux wrote:
> > On Tue, Sep 18, 2012 at 10:00:37AM +0200, Thierry Reding wrote:
> > > On Sat, Sep 15, 2012 at 10:31:52PM +0100, Russell King - ARM Linux wrote:
> > > > On Wed, Sep 12, 2012 at 10:43:07PM +0200, Lars-Peter Clausen wrote:
> > > > > I wouldn't mind having this merged sooner rather than later, there is at least
> > > > > one driver in next which is currently broken due to the missing devm_clk_get.
> > > > > Russell what's your plan for the patch? Maybe under the given circumstances it
> > > > > makes sense to let it go through the m68k tree.
> > > > 
> > > > Ok, I've merged it but there was no indication in the patch that it was
> > > > supposed to be a fix... there's no cc: to stable.  Does it need to go to
> > > > stable?  When was this brokenness introduced?  What's the story for the
> > > > m68k bit?

I said abouve "I've merged it" - that means, I've put it in my
tree...

> > > What tree is this supposed to go through? I've checked your ARM tree as
> > > well as Mike's clock tree but neither seem to carry this patch. The
> > > reason I ask is because I want to take a patch series that converts the
> > > Unicore32 PWM code to the PWM framework into linux-next but it depends
> > > on this patch as well.
> > 
> > It /is/ in my tree (you'll notice that it is in linux-next.)  You're
> > probably looking at my Linaro tree instead, which doesn't carry
> > anything which isn't about to be sent to Linus.
> 
> I must be blind then. next-20120918 doesn't have it. And looking at your
> tree here[0] doesn't show the commit either.

Hmm, it's possible I didn't push the tree out... well, I have done so
now, so it should be visible from tonight onwards and should be in
-next sometime during the next couple of days (it seems to take a
couple of days between me pushing stuff out one evening to stuff
appearing in -next because of the timezones and timing of sfr's pulls.)
