Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732Ab2EKNFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 09:05:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:20134 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759648Ab2EKNFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 09:05:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164942964"
Date: Fri, 11 May 2012 15:14:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        broonie@opensource.wolfsonmicro.com, jedu@slimlogic.co.uk,
        lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] mfd:tps65910: use devm_* and register gpio as
 platform driver
Message-ID: <20120511131454.GI1214@sortiz-mobl>
References: <1336569057-3890-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336569057-3890-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Wed, May 09, 2012 at 06:40:53PM +0530, Laxman Dewangan wrote:
> This series does cleanup in the mfd/tps65910 as follows:
> - Do not cache the register when initailizing regmap. Cache when
>   actually when we need it.
> - Convert the allocation to use devm_* apis.
> - Move the gpio as platform driver and register it as mfd sub devices.
> 
> Laxman Dewangan (4):
>   mfd: tps65910: cache register when we need it
> 	Remove the chaching of register in regmap initialization.
> 
>   mfd: tps65910: convert all allocation to devm_*
> 	Convert the allocation to use devm_* apis.
> 
>   mfd: tps65910: register gpio as mfd device
>   gpio: tps65910: move this as platform driver
> 	Above two patch to make gpio driver as platform driver and register
> 	as mfd sub device from core driver.
> 	
I applied patches 1, 2 and 3. Patch #4 does not apply cleanly to my for-next
branch, could you please rebase it ?
Also, having Grant's ACK for it would be nice.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
