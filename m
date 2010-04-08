Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab0DHJeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 05:34:44 -0400
Received: from mga05.intel.com ([192.55.52.89]:57774 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755681Ab0DHJem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 05:34:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,169,1270450800"; 
   d="scan'208";a="556075845"
Date: Thu, 8 Apr 2010 11:35:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Fix WM831x I2C suspend prototype
Message-ID: <20100408093516.GC3075@sortiz.org>
References: <1270642522-17468-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270642522-17468-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 01:15:22PM +0100, Mark Brown wrote:
> Sorry about the oversight.
No problem. I wonder how that slipped through my compile tests...
Anyway, I merged it with your last wm831x-core patch.

Cheers,
Samuel.

 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm831x-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
> index d4331b2..1a968f3 100644
> --- a/drivers/mfd/wm831x-core.c
> +++ b/drivers/mfd/wm831x-core.c
> @@ -1767,7 +1767,7 @@ static int wm831x_i2c_remove(struct i2c_client *i2c)
>  	return 0;
>  }
>  
> -static int wm831x_i2c_suspend(struct i2c_client *i2c)
> +static int wm831x_i2c_suspend(struct i2c_client *i2c, pm_message_t mesg)
>  {
>  	struct wm831x *wm831x = i2c_get_clientdata(i2c);
>  
> -- 
> 1.7.0.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
