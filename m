Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2EGJdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 05:33:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:60668 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898Ab2EGJdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 05:33:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="97144404"
Date: Mon, 7 May 2012 11:33:08 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] mfd: tps65090: Fix ifdefs for suspend mode
Message-ID: <20120507093308.GD3229@sortiz-mobl>
References: <1336381403-7840-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336381403-7840-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, May 07, 2012 at 10:03:17AM +0100, Mark Brown wrote:
> CONFIG_PM also covers runtime only PM.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Acked-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
>  drivers/mfd/tps65090.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
This one and the 6 following patches applied to my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
