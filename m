Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab2IJAPr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 20:15:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56757 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab2IJAPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 20:15:46 -0400
Date: Mon, 10 Sep 2012 01:15:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mike Turquette <mturquette@ti.com>,
        Greg Ungerer <gerg@uclinux.org>, Julia Lawall <julia.lawall@lip6.fr>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: Make the managed clk functions generically
	available
Message-ID: <20120910001524.GL13739@n2100.arm.linux.org.uk>
References: <1347202862-1617-1-git-send-email-lars@metafoo.de> <20120909235059.GA2643@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120909235059.GA2643@sirena.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 12:50:59AM +0100, Mark Brown wrote:
> On Sun, Sep 09, 2012 at 05:01:02PM +0200, Lars-Peter Clausen wrote:
> 
> > The managed clk functions are currently only available when the generic clk
> > lookup framework is build. But the managed clk functions are merely wrappers
> > around clk_get and clk_put and do not depend on any specifics of the generic
> > lookup functions and there are still quite a few custom implementations of the
> > clk API. So make the managed functions available whenever the clk API is
> > implemented.
> 
> > The patch also removes the custom implementation of devm_clk_get for the
> > coldfire platform.
> 
> I posted a patch for this (clk: Move devm_ APIs out of clkdev into
> HAVE_CLK) towards the end of the last release cycle and I think reposted
> it since and it had been sent to the patch tracker too (though I can't
> find any record of anything except the submission mail now).  It would
> be *really* good to get this merged.

Note that the patch system doesn't always return error messages anymore
(it used to do that reliably, but as it's now a favourite target for
spammers and was creating soo much backscatter, which was then filling
my mailbox with bounces... that had to change.)

However, it will always return a message for a patch that it adds to the
database, so if you don't get that then it means something went wrong
somewhere and you should check to see whether it exists in the database
in case it's the emailed response which got lost.

Email today still remains an unreliable transmission medium - there is
no guarantee that any message sent will get to its destination, and in
the same way, there is no guarantee that any acknowledgement (or NDR)
will get back to the originator.

> Who's looking after clkdev these days?  Mike doesn't seem to take
> patches as he's expecting Russell to take them which was happening for a
> while but I'm not sure that's the case any more, especially given
> Russell's followup here.  Due to the patch tracker the usual things for
> following up on unapplied patches don't work terribly well, it's much
> less likely that it's just an oversight there.

Well, in theory I'm the maintainer for clkdev and clk API, so I should
take the patch...
