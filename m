Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab2CODDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 23:03:33 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:35088
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246Ab2CODDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 23:03:31 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 15 Mar 2012 11:05:09 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "vinod.koul@linux.intel.com" <vinod.koul@linux.intel.com>
Subject: Re: [PATCH v1 1/5] ARM: imx28: add basic dt support
Message-ID: <20120315030508.GC13022@shlinux2.ap.freescale.net>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <1331628428-24017-2-git-send-email-b29396@freescale.com>
 <20120314194123.GR26642@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120314194123.GR26642@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 03:41:23AM +0800, Sascha Hauer wrote:
> On Tue, Mar 13, 2012 at 04:47:04PM +0800, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > This patch includes basic dt support which can boot via nfs rootfs.
> > 
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/arm/fsl.txt |    4 +
> >  arch/arm/boot/dts/imx28-evk.dts               |   31 +++++++++
> >  arch/arm/boot/dts/imx28.dtsi                  |   88 +++++++++++++++++++++++++
> >  arch/arm/mach-mxs/Kconfig                     |    9 +++
> >  arch/arm/mach-mxs/Makefile                    |    1 +
> >  arch/arm/mach-mxs/imx28-dt.c                  |   67 +++++++++++++++++++
> >  6 files changed, 200 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/arm/fsl.txt b/Documentation/devicetree/bindings/arm/fsl.txt
> > index 54bddda..9f21faf 100644
> > --- a/Documentation/devicetree/bindings/arm/fsl.txt
> > +++ b/Documentation/devicetree/bindings/arm/fsl.txt
> > @@ -1,6 +1,10 @@
> 
> > +
> > +static const char *imx28_dt_compat[] __initdata = {
> > +	"fsl,imx28-evk",
> > +	NULL,
> > +};
> > +
> 
> I suggest to add a generic "fsl,imx28" entry here. It helps people to
> start an unpatched kernel on their boards.
> 
Good point.
Thanks for reminder.

Regards
Dong Aisheng

