Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab2K3LVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:21:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:21721 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756121Ab2K3LVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:21:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="257106068"
Date: Fri, 30 Nov 2012 12:21:34 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mfd: tps65910: fix wrong ack_base register
Message-ID: <20121130112134.GP3176@sortiz-mobl>
References: <A874F61F95741C4A9BA573A70FE3998F6418F154@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F6418F154@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Milo,

On Thu, Nov 29, 2012 at 06:42:12AM +0000, Kim, Milo wrote:
>  The interrupt status registers of TPS65910/1 should be cleared
>  when the associated interrupt event occurs.
>  This work is done in the regmap irq thread - using 'ack_base' register.
>  The ACK registers should be fixed as status register, not mask registers.
> 
>  This patch fixes the infinite interrupt event problem by clearing
>  interrupt status registers.
> 
>  Tested on the AM3517 Craneboard.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/mfd/tps65910.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
