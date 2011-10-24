Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab1JXJHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:07:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41025 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab1JXJHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:07:52 -0400
Date: Mon, 24 Oct 2011 11:07:34 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Tony Lindgren <tony@atomide.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, patches@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111024090734.GD8708@ponder.secretlab.ca>
References: <20111019053354.GB31162@S2100-06.ap.freescale.net>
 <20111019144734.GI18713@sirena.org.uk>
 <20111019150448.GB32007@S2100-06.ap.freescale.net>
 <20111019151031.GA4275@opensource.wolfsonmicro.com>
 <4E9F9892.9070007@ti.com>
 <20111020094140.GK18713@sirena.org.uk>
 <20111020162743.GB31337@atomide.com>
 <20111020164006.GA10155@sirena.org.uk>
 <20111020170534.GC31337@atomide.com>
 <20111020172218.GE31337@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020172218.GE31337@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 10:22:19AM -0700, Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [111020 09:31]:
> > 
> > That's where a DT entry specific configuration string might be the best
> > option as it still allows describing the hardware using DT standards,
> > while also allowing board specific configuration too.
> 
> Hmm, actually, can't we just pass the board specific configuration in
> the board specific .dts file and then it gets merged in with the
> arch independent DT node?

It would be fine to, say, have a omap-specific board configuration
node for collecting things that really don't fit anywhere else.  That
would be in some ways analogous to the way we've decided to use top a
top level node for describing a machines audio complex.

g.

