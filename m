Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab1JCRFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 13:05:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56513 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab1JCRFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 13:05:14 -0400
Date: Mon, 3 Oct 2011 18:05:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: jeremy.kerr@canonical.com, paul@pwsan.com, linaro-dev@lists.linaro.org,
        linus.walleij@stericsson.com, tglx@linutronix.de, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, magnus.damm@gmail.com,
        linux-kernel@vger.kernel.org, eric.miao@linaro.org,
        grant.likely@secretlab.ca, dsaxena@linaro.org,
        amit.kucheria@linaro.org, skannan@quicinc.com,
        arnd.bergmann@linaro.org, sboyd@quiinc.com, richard.zhao@linaro.org,
        shawn.guo@freescale.com, Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Message-ID: <20111003170503.GI23811@sirena.org.uk>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-2-git-send-email-mturquette@ti.com>
 <4E89C3FA.9020206@gmail.com>
 <20111003142524.GN3731@opensource.wolfsonmicro.com>
 <4E89D3C4.8090001@gmail.com>
 <20111003163107.GQ3731@opensource.wolfsonmicro.com>
 <20111003164309.GA19925@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003164309.GA19925@n2100.arm.linux.org.uk>
X-Cookie: Batteries not included.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 05:43:09PM +0100, Russell King - ARM Linux wrote:
> On Mon, Oct 03, 2011 at 05:31:08PM +0100, Mark Brown wrote:

[Not being many off-SoC clocks]
> > I dunno, I get the impression that some of this is due to the current
> > limitations of the clock API rather than due to a lack of clocks -
> > perhaps that's specific to the applications I look at, though.
> > applications 

> The clk API per-se has nothing to do with how clocks are registered.
> There are two things that are the clk API:

Right, it's consumer side only which is the limitation I'm talking about
- at the minute it's only possible to use the clk API for on-SoC clocks
(or at least clocks that the SoC cares about), we don't have a clock API
for cross platform clock providers.  I don't know if getting a cross
platform implementation will change that situation much.
