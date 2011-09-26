Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1IZUSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 16:18:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59544 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab1IZUSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 16:18:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6481"; a="121708600"
Date: Mon, 26 Sep 2011 13:18:36 -0700
From: David Brown <davidb@codeaurora.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v3 0/3] genirq: handling GIC per-cpu interrupts
Message-ID: <20110926201836.GA27355@huya.qualcomm.com>
References: <1316793788-14500-1-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316793788-14500-1-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 05:03:05PM +0100, Marc Zyngier wrote:

> Tested on ARM Versatile Express (Cortex A15), ARM RealView PB11MP,
> OMAP4 (Panda) and Tegra (Harmony). Patch series against next-20110923.
> 
> From v2:
> - Fixed !GENERIC_HARDIRQS build
> - Fixed request_percpu_irq documentation
> 
> From v1:
> - General tidy-up after Thomas' review. I've kept the config option
>   for the time being until we can sort out the anonymous union
>   problem.
> 
> Marc Zyngier (3):
>   genirq: add support for per-cpu dev_id interrupts
>   ARM: gic: consolidate PPI handling
>   ARM: gic, local timers: use the request_percpu_irq() interface

I've tested this on an MSM8660 based off of next-20110926.

Tested-by: David Brown <davidb@codeaurora.org>
Acked-by: David Brown <davidb@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
