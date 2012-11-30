Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab2K3LEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:04:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:16630 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682Ab2K3LEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:04:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="257101132"
Date: Fri, 30 Nov 2012 12:04:38 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: da9052-core: Fix interrupts reported to mfd child
 devices
Message-ID: <20121130110438.GO3176@sortiz-mobl>
References: <1354201468-9219-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354201468-9219-1-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Thu, Nov 29, 2012 at 04:04:28PM +0100, Philipp Zabel wrote:
> The patch "mfd: da9052-core: Use regmap_irq_get_virq() and fix the probe"
> replaces the irq_base with the da9052_map_irq function but doesn't
> update the irq_base parameter to the mfd_add_devices call.
> This causes child devices to try and request IRQs with just the internal
> offset number.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/mfd/da9052-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied, although I'd like to get Fabio's ACK on it.
I think this is a problem he should have seen, although he could have missed
it since the original patch is a fairly old one and there have been some MFD
API changes in between.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
