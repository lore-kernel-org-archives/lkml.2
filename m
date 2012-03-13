Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab2CMQw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:52:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41103 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab2CMQwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:52:25 -0400
Date: Tue, 13 Mar 2012 17:52:14 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Dong Aisheng <b29396@freescale.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, vinod.koul@linux.intel.com,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        rdunlap@xenotime.net, kernel@pengutronix.de, cjb@laptop.org,
        shawn.guo@freescale.com
Subject: Re: [PATCH v1 3/5] ARM: imx28evk: add mmc dt support
Message-ID: <20120313165214.GO26642@pengutronix.de>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <1331628428-24017-4-git-send-email-b29396@freescale.com>
 <4F5F5C22.1080506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5F5C22.1080506@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:50:42 up 122 days, 37 min, 73 users,  load average: 0.04, 0.03,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 09:39:30AM -0500, Rob Herring wrote:
> On 03/13/2012 03:47 AM, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > ---
> >  arch/arm/boot/dts/imx28-evk.dts |   14 ++++++++++++++
> >  arch/arm/boot/dts/imx28.dtsi    |   33 +++++++++++++++++++++++++++++++++
> >  arch/arm/mach-mxs/imx28-dt.c    |    2 ++
> >  3 files changed, 49 insertions(+), 0 deletions(-)
> 
> snip
> 
> > diff --git a/arch/arm/mach-mxs/imx28-dt.c b/arch/arm/mach-mxs/imx28-dt.c
> > index 78d1129..429b88e 100644
> > --- a/arch/arm/mach-mxs/imx28-dt.c
> > +++ b/arch/arm/mach-mxs/imx28-dt.c
> > @@ -23,6 +23,8 @@ static const struct of_dev_auxdata imx28_auxdata_lookup[] __initconst = {
> >  	OF_DEV_AUXDATA("arm,pl011", MX28_DUART_BASE_ADDR, "duart", NULL),
> >  	OF_DEV_AUXDATA("fsl,imx28-fec", MX28_ENET_MAC0_BASE_ADDR, "imx28-fec.0", NULL),
> >  	OF_DEV_AUXDATA("fsl,imx28-fec", MX28_ENET_MAC1_BASE_ADDR, "imx28-fec.1", NULL),
> > +	OF_DEV_AUXDATA("fsl,imx28-mmc", MX28_SSP0_BASE_ADDR, "mxs-mmc.0", NULL),
> > +	OF_DEV_AUXDATA("fsl,imx28-mmc", MX28_SSP1_BASE_ADDR, "mxs-mmc.1", NULL),
> 
> Why is this needed?

These are needed for the drivers which have still the mxs-mmc.* names
to find their clocks. Alternatively we could also add the appropriate
clocks to the clock file. Don't know if that's better though.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
