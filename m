Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab2DRD3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 23:29:53 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:13291
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752152Ab2DRD3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 23:29:52 -0400
X-SpamScore: -13
X-BigFish: VS-13(zcb8kzbb2dI9371I1432N98dK1447Mzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 18 Apr 2012 11:40:28 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH 2/3] pinctrl: pinctrl-imx: add imx6q pinctrl driver
Message-ID: <20120418034027.GB18021@shlinux2.ap.freescale.net>
References: <1334333915-1174-1-git-send-email-b29396@freescale.com>
 <1334333915-1174-2-git-send-email-b29396@freescale.com>
 <4F8DCEC2.2060800@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F8DCEC2.2060800@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 04:12:50AM +0800, Stephen Warren wrote:
> On 04/13/2012 10:18 AM, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> 
> > diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
> 
> >  static const struct of_device_id imx_pmx_dt_ids[] = {
> > +#ifdef CONFIG_PINCTRL_IMX6Q
> > +	{ .compatible = "fsl,imx6q-iomuxc", .data = (void *) &imx6q_pinctrl_info, },
> > +#endif
> >  	{ /* sentinel */ }
> >  };
> >  MODULE_DEVICE_TABLE(of, imx_pmx_dt_ids);
> 
> Sorry for the slow review.
> 
> Based on SPEAr pinctrl review comments, we shouldn't have a single
> driver that knows about all the different SoCs that it could support,
> but rather one driver per SoC, with each of those calling into some
> utility code in the core driver to do all the probe/remove work.
> 
Sound like a good idea.

> For more details, see commit a4c0738 "pinctrl: tegra: refactor probe
> handling" in
> git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git
> (in branch for-3.5/gpio-pinmux).
> 
I will check it.
Thanks for the reminder.

Regards
Dong Aisheng

