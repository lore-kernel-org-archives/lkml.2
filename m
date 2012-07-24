Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab2GXWl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 18:41:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:41670 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453Ab2GXWlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 18:41:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172736683"
Date: Wed, 25 Jul 2012 00:41:51 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        swarren@nvidia.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 0/6] mfd: tp6586x: enhancements in the driver
Message-ID: <20120724224151.GC11304@sortiz-mobl>
References: <1342592450-12488-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342592450-12488-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Wed, Jul 18, 2012 at 11:50:44AM +0530, Laxman Dewangan wrote:
> Doing some enhancements in the tps6586x core driver which is
> based on some recent driver framework enhancements.
> Following are highlights of changes:
> - Use devm for allocation to remove the code for freeing it.
> - Use regmap i2c for register access in place of direct i2c apis.
>   This will give the debug fs and cache functionality through regmap
>   framework.
> - Use the regmap caching for some fo register in place of local
>   implementation.
> - Move the gpio support driver to the drivers/gpio and implement it as
>   platform driver. The registration will be done as mfd sub devices.
Nice, all 6 patches applied. I had to manually apply #5, please let me know if
there are some issues.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
