Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab2IOVdi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 17:33:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33725 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab2IOVd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 17:33:27 -0400
Date: Sat, 15 Sep 2012 22:31:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Greg Ungerer <gerg@snapgear.com>, dedekind1@gmail.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@ti.com>, Greg Ungerer <gerg@uclinux.org>,
        Julia Lawall <julia.lawall@lip6.fr>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] clk: Make the managed clk functions generically
	available
Message-ID: <20120915213151.GM12245@n2100.arm.linux.org.uk>
References: <1347202862-1617-1-git-send-email-lars@metafoo.de> <20120909235059.GA2643@sirena.org.uk> <20120910001524.GL13739@n2100.arm.linux.org.uk> <20120910002020.GB16249@opensource.wolfsonmicro.com> <20120910003913.GM13739@n2100.arm.linux.org.uk> <504F4E36.20309@metafoo.de> <1347375033.27206.3.camel@sauron.fi.intel.com> <504FE633.2090304@snapgear.com> <5050F3DB.1050202@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5050F3DB.1050202@metafoo.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 10:43:07PM +0200, Lars-Peter Clausen wrote:
> I wouldn't mind having this merged sooner rather than later, there is at least
> one driver in next which is currently broken due to the missing devm_clk_get.
> Russell what's your plan for the patch? Maybe under the given circumstances it
> makes sense to let it go through the m68k tree.

Ok, I've merged it but there was no indication in the patch that it was
supposed to be a fix... there's no cc: to stable.  Does it need to go to
stable?  When was this brokenness introduced?  What's the story for the
m68k bit?

(Cc on this thread to stable added so they can hear the reply... so if
it does end up with a Cc: being added to the commit, they have the
background... this is *not* a stable submission request.)
