Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab2ICDIP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 23:08:15 -0400
Received: from [216.32.181.184] ([216.32.181.184]:45782 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755010Ab2ICDIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 23:08:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zcb8kz98dI1432Izz1202h1082kzz8275dhz2dh2a8h668h839h944hd25hf0ah107ah1220h1155h)
Date: Mon, 3 Sep 2012 10:46:06 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Zhao Richard-B20223 <B20223@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
Subject: Re: [PATCH v4 2/7] ARM: imx6q: add iomuxc gpr support into syscon
Message-ID: <20120903024606.GC11891@shlinux2.ap.freescale.net>
References: <1346237818-9498-1-git-send-email-b29396@freescale.com>
 <1346237818-9498-3-git-send-email-b29396@freescale.com>
 <20120831020247.GC7726@r65073-Latitude-D630>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120831020247.GC7726@r65073-Latitude-D630>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 10:02:48AM +0800, Shawn Guo wrote:
> On Wed, Aug 29, 2012 at 06:56:53PM +0800, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > Include headfile for easy using.
> > 
> > Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > ---
> >  arch/arm/boot/dts/imx6q.dtsi         |    5 +
> >  include/linux/fsl/imx6q-iomuxc-gpr.h |  319 ++++++++++++++++++++++++++++++++++
> 
> I assume that all the users of this header file are imx6q syscon
> clients.  In that case, this header belongs to mfd/syscon subsystem.
> 
> I have been told by people that it was a mistake to create
> include/linux/fsl.  Each header in include/linux should go to
> respective subsystem sub-directory.  For this particular case,
> it should be include/linux/mfd or include/linux/mfd/syscon even
> better, IMO.
> 
I like the later one if not put in include/linux/fsl. :)

> > +#define IMX6Q_GPR13_SATA_PHY_1_MED		(0x1 << 0)
> > +#define IMX6Q_GPR13_SATA_PHY_1_SLOW		(0x2 << 0)
> > +
> > +#endif /* !__LINUX_IMX6Q_IOMUXC_GPR_H */
> 
> Nit: why do we have a "!" there?
> 
You're right.
We do not need a '!' for such macro.
Sorry for my mistake.

Regards
Dong Aisheng

