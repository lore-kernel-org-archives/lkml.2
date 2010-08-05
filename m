Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315Ab0HEQ0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:26:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:11224 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601Ab0HEQ0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:26:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,323,1278313200"; 
   d="scan'208";a="308626142"
Date: Thu, 5 Aug 2010 18:26:16 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Missing slab.h includes
Message-ID: <20100805162615.GC7722@sortiz-mobl>
References: <20100804.225714.98906531.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804.225714.98906531.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Wed, Aug 04, 2010 at 10:57:14PM -0700, David Miller wrote:
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
> 
> I'm getting build failures with Linus's current tree without
> these.  Apologies if this is already fixed and just queued up
> in a GIT tree somewhere.
No this is not queued in my tree, I haven't seen this build failure.
Patch applied, many thanks.

Cheers,
Samuel.


> diff --git a/drivers/mfd/janz-cmodio.c b/drivers/mfd/janz-cmodio.c
> index 9ed6307..36a166b 100644
> --- a/drivers/mfd/janz-cmodio.c
> +++ b/drivers/mfd/janz-cmodio.c
> @@ -18,6 +18,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/delay.h>
>  #include <linux/platform_device.h>
> +#include <linux/slab.h>
>  #include <linux/mfd/core.h>
>  
>  #include <linux/mfd/janz.h>

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
