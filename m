Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2AJPak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 10:30:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56645 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab2AJPai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 10:30:38 -0500
Date: Tue, 10 Jan 2012 23:41:12 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: devicetree-discuss@lists.ozlabs.org, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Jamie Iles <jamie@jamieiles.com>,
        "open list:ARM/ATMEL AT91RM9..." 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:ARM/QUALCOMM MSM..." <linux-arm-msm@vger.kernel.org>,
        "open list:OMAP SUPPORT" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2] irqdomain: Initialize number of IRQs for simple
 domains
Message-ID: <20120110154109.GB27831@S2101-09.ap.freescale.net>
References: <1326191059-26411-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326191059-26411-1-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 11:24:11AM +0100, Thierry Reding wrote:
> The irq_domain_add() function needs the number of interrupts in the
> domain to properly initialize them. In addition the allocated domain
> is now returned by the irq_domain_{add,generate}_simple() helpers.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: David Brown <davidb@codeaurora.org>
> ---
> Note: This patch should not be applied yet. There is a conflict with a
>       pending patch[0] by Benoit Cousson that will obsolete the OMAP2
>       hunk in this patch.
> 
>       [0]: http://www.spinics.net/lists/linux-omap/msg62124.html
> 
> Changes in v2:
>  - Don't use ERR_PTR, keep the WARN_ON(1) and return NULL as requested
>    by Grant Likely.
>  - Integrate i.MX cleanup patch by Shawn Guo.
> 
...
>  arch/arm/mach-imx/imx51-dt.c          |   13 +++++++++++--
>  arch/arm/mach-imx/imx53-dt.c          |   13 +++++++++++--
>  arch/arm/mach-imx/mach-imx6q.c        |    6 +++++-
...
>  arch/arm/plat-mxc/include/mach/irqs.h |   13 +++++++------
>  arch/arm/plat-mxc/tzic.c              |    2 --

Acked-by: Shawn Guo <shawn.guo@linaro.org>

Regards,
Shawn
