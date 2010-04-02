Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab0DBKL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 06:11:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:35371 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757973Ab0DBKLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 06:11:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,352,1267430400"; 
   d="scan'208";a="505807047"
Date: Fri, 2 Apr 2010 12:12:00 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Tejun Heo <tj@kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/17] mfd: update gfp/slab.h includes
Message-ID: <20100402101159.GC8010@sortiz.org>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
 <1269885165-18617-13-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269885165-18617-13-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Tue, Mar 30, 2010 at 02:52:40AM +0900, Tejun Heo wrote:
> Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> gfp.h or slab.h is included as necessary.
The davinci MFD driver is sitting in Mark's tree, so I guess he should take
this patch.
Mark, feel free to add my:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

to this patch.

Cheers,
Samuel.


> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/gpio/rdc321x-gpio.c      |    1 +
>  drivers/mfd/davinci_voicecodec.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/rdc321x-gpio.c b/drivers/gpio/rdc321x-gpio.c
> index 46c5519..e344907 100644
> --- a/drivers/gpio/rdc321x-gpio.c
> +++ b/drivers/gpio/rdc321x-gpio.c
> @@ -27,6 +27,7 @@
>  #include <linux/pci.h>
>  #include <linux/gpio.h>
>  #include <linux/mfd/rdc321x.h>
> +#include <linux/slab.h>
>  
>  struct rdc321x_gpio {
>  	spinlock_t		lock;
> diff --git a/drivers/mfd/davinci_voicecodec.c b/drivers/mfd/davinci_voicecodec.c
> index 9886aa8..3e75f02 100644
> --- a/drivers/mfd/davinci_voicecodec.c
> +++ b/drivers/mfd/davinci_voicecodec.c
> @@ -23,6 +23,7 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/device.h>
> +#include <linux/slab.h>
>  #include <linux/delay.h>
>  #include <linux/io.h>
>  #include <linux/clk.h>
> -- 
> 1.6.4.2
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
