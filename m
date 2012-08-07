Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab2HGCJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 22:09:01 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:27862
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757057Ab2HGCJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 22:09:00 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(z37d5kz98dIzz1202hzzz2dh87h2a8h668h839h944hd25he96hf0ah107ah)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 7 Aug 2012 10:09:09 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Matt Sealey <matt@genesi-usa.com>
CC: Robert Schwebel <r.schwebel@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linaro-kernel@lists.linaro.org>, Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 4/9] ASoC: imx: Don't use {en,dis}able_fiq() calls
Message-ID: <20120807020907.GB24289@S2101-09.ap.freescale.net>
References: <20120805230238.GA1663@lizard>
 <1344207819-3415-4-git-send-email-anton.vorontsov@linaro.org>
 <CAKGA1bkiHj=zMJXSzoGp3fpLS3POnFXSV5y7sYYFAikqoUT9tQ@mail.gmail.com>
 <20120806154951.GQ16861@opensource.wolfsonmicro.com>
 <CAKGA1b=_AOub_pEJJGBTb6Y7wLZaSYKQjFTyMVFSr_=9VX4wpg@mail.gmail.com>
 <20120806193734.GA16199@opensource.wolfsonmicro.com>
 <20120806201609.GX25644@pengutronix.de>
 <CAKGA1bmMqyL4gyLYcanEH=R=HuBjRCNRLjUEWCj8wmpi3HuL0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKGA1bmMqyL4gyLYcanEH=R=HuBjRCNRLjUEWCj8wmpi3HuL0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:39:50PM -0500, Matt Sealey wrote:
> * make sure there's no weird FIQ stuff floating around that has so far
> relied on SND_SOC_IMX_PCM_FIQ doing select FIQ before I make it not

Acked on changing SND_IMX_SOC to SND_SOC_IMX_PCM_FIQ in
arch/arm/plat-mxc/Makefile.

> compile in for other boards (since otherwise no i.MX processor selects
> FIQ if they're not using that driver, it could be simply coincidence
> nobody noticed). I don't want to be the one submitting a patch I can't
> test which mysteriously breaks every MX28 on the planet (since Rob,
> Shawn, Sascha might be the ones swearing at me instead)
> 
Though i.MX23 and i.MX28 are named in i.MX family, they are actually
a different architecture from IMX/MXC.  It's MXS, nothing to do with
SSI.  Folder sound/soc/mxs/ is the one for i.MX28.

-- 
Regards,
Shawn

