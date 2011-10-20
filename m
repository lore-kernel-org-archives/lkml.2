Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab1JTJlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:41:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56565 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab1JTJlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:41:50 -0400
Date: Thu, 20 Oct 2011 10:41:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: patches@linaro.org, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        lrg@ti.com, Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111020094140.GK18713@sirena.org.uk>
References: <1318263578-7407-4-git-send-email-rnayak@ti.com>
 <20111016145536.GA29885@S2100-06.ap.freescale.net>
 <4E9BAC4D.3010402@ti.com>
 <20111018115836.GC30703@S2100-06.ap.freescale.net>
 <20111018160046.GD28501@opensource.wolfsonmicro.com>
 <20111019053354.GB31162@S2100-06.ap.freescale.net>
 <20111019144734.GI18713@sirena.org.uk>
 <20111019150448.GB32007@S2100-06.ap.freescale.net>
 <20111019151031.GA4275@opensource.wolfsonmicro.com>
 <4E9F9892.9070007@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9F9892.9070007@ti.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 09:12:10AM +0530, Rajendra Nayak wrote:
> On Wednesday 19 October 2011 08:40 PM, Mark Brown wrote:

> >I don't see any issue with leaving some things out of the DT bindings;
> >you were the one raising that as a concern.

> The problem is, that there doesn't seem to be a clean way to embed
> *board data* into the kernel with DT, if left out of the DT bindings.
> There is the auxdata way of still attaching platform_data, but that I
> thought was a stopgap for just handling function pointers.

We can always start off just completely omitting the data and then see
how we go from there.  If we only cover 50% of users that's still 50%
more than are currently covered with device tree right now and it means
we can then spin round and look at the bits that are hard again without
review fatigue on the bits that are easy.
