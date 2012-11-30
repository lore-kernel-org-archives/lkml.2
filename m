Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab2K3LW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:22:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:52858 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756121Ab2K3LW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:22:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="249758523"
Date: Fri, 30 Nov 2012 12:22:02 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mfd: tps65910: remove unused data
Message-ID: <20121130112202.GQ3176@sortiz-mobl>
References: <A874F61F95741C4A9BA573A70FE3998F6418F1BB@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F6418F1BB@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Milo,

On Thu, Nov 29, 2012 at 08:48:26AM +0000, Kim, Milo wrote:
>  The 'io_mutex' is not used anywhere.
>  The regmap API supports the mutex internally, so no additional mutex required.
> 
>  And 'domain' private data is unnecessary because the irq domain is
>  already registered by using regmap_add_irq_chip().
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/mfd/tps65910.c       |    1 -
>  include/linux/mfd/tps65910.h |    2 --
>  2 files changed, 3 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
