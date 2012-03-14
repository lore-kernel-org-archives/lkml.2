Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab2CNHuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:50:06 -0400
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:55014 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756080Ab2CNHuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:50:02 -0400
Date: Wed, 14 Mar 2012 08:30:35 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Dong Aisheng <b29396@freescale.com>,
        vinod.koul@linux.intel.com, devicetree-discuss@lists.ozlabs.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, rdunlap@xenotime.net, kernel@pengutronix.de,
        cjb@laptop.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH v1 3/5] ARM: imx28evk: add mmc dt support
Message-ID: <20120314073035.GI18320@game.jcrosoft.org>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <1331628428-24017-4-git-send-email-b29396@freescale.com>
 <4F5F5C22.1080506@gmail.com>
 <20120313165214.GO26642@pengutronix.de>
 <4F5F879E.4030407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5F879E.4030407@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 5468214373213842396
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrfeejucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrfeejucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:45 Tue 13 Mar     , Rob Herring wrote:
> On 03/13/2012 11:52 AM, Sascha Hauer wrote:
> > On Tue, Mar 13, 2012 at 09:39:30AM -0500, Rob Herring wrote:
> >> On 03/13/2012 03:47 AM, Dong Aisheng wrote:
> >>> From: Dong Aisheng <dong.aisheng@linaro.org>
> >>>
> >>> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> >>> ---
> >>>  arch/arm/boot/dts/imx28-evk.dts |   14 ++++++++++++++
> >>>  arch/arm/boot/dts/imx28.dtsi    |   33 +++++++++++++++++++++++++++++++++
> >>>  arch/arm/mach-mxs/imx28-dt.c    |    2 ++
> >>>  3 files changed, 49 insertions(+), 0 deletions(-)
> >>
> >> snip
> >>
> >>> diff --git a/arch/arm/mach-mxs/imx28-dt.c b/arch/arm/mach-mxs/imx28-dt.c
> >>> index 78d1129..429b88e 100644
> >>> --- a/arch/arm/mach-mxs/imx28-dt.c
> >>> +++ b/arch/arm/mach-mxs/imx28-dt.c
> >>> @@ -23,6 +23,8 @@ static const struct of_dev_auxdata imx28_auxdata_lookup[] __initconst = {
> >>>  	OF_DEV_AUXDATA("arm,pl011", MX28_DUART_BASE_ADDR, "duart", NULL),
> >>>  	OF_DEV_AUXDATA("fsl,imx28-fec", MX28_ENET_MAC0_BASE_ADDR, "imx28-fec.0", NULL),
> >>>  	OF_DEV_AUXDATA("fsl,imx28-fec", MX28_ENET_MAC1_BASE_ADDR, "imx28-fec.1", NULL),
> >>> +	OF_DEV_AUXDATA("fsl,imx28-mmc", MX28_SSP0_BASE_ADDR, "mxs-mmc.0", NULL),
> >>> +	OF_DEV_AUXDATA("fsl,imx28-mmc", MX28_SSP1_BASE_ADDR, "mxs-mmc.1", NULL),
> >>
> >> Why is this needed?
> > 
> > These are needed for the drivers which have still the mxs-mmc.* names
> > to find their clocks. Alternatively we could also add the appropriate
> > clocks to the clock file. Don't know if that's better though.
> 
> Ah, yes I should have known that... If clk lookup is all that's needed,
> I'd suggest adding the necessary clk lookups either here or in the clock
> code. Not much difference, but at least it removes the use of
> *_BASE_ADDR defines.
Agreed we do this on AT91

Best Regards,
J.
