Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2BFTls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:41:48 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49167 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab2BFTlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:41:47 -0500
Date: Mon, 6 Feb 2012 19:41:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Dong Aisheng <dongas86@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "ext Tony Lindgren (tony@atomide.com)" <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: An extremely simplified pinctrl bindings proposal
Message-ID: <20120206194125.GA23030@sirena.org.uk>
References: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com>
 <CACRpkdahin4srDh7dphgvq306gjz7CGP=h4dVkUY+w0z0wpXRQ@mail.gmail.com>
 <4F2F6AE2.1040504@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2F6AE2.1040504@nvidia.com>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 05, 2012 at 09:53:38PM -0800, Stephen Warren wrote:
> On 02/05/2012 08:20 PM, Linus Walleij wrote:

> > A controlled set of register read/writes and maybe also conditionals
> > (if that bit is 1, do this, else do that, plus a loop command to wait
> > for a flag or similar) are known as a "jam tables" and usually used
> > in BIOSes to do a compact machine initialization. I learned this term
> > in Bunnie Huang's "Hacking the Xbox, where he describes finding a
> > jam table interpreter in the Xbox ROM.

FWIW I just added a subset of this functionality (called "patches" for
want of a better name) to regmap, just a simple list of register writes
that get blasted in htere.  The intent is somewhat different, though -
it's there for dumping undocumented or partially documented register
write sequences from vendors into devices since there's a common pattern
of doing that when bringing things out of reset, more like what Grant
seems to have been talking about in that thread.
