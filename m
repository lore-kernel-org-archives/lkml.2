Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2KXIcN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 03:32:13 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50711 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab2KXIcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 03:32:07 -0500
Date: Sat, 24 Nov 2012 00:32:03 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] input: twl4030-pwrbutton: Change
 TWL4030_MODULE_PM_MASTER to TWL_MODULE_PM_MASTER
Message-ID: <20121124083203.GF24711@core.coreip.homeip.net>
References: <1352799508-22212-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352799508-22212-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 10:38:28AM +0100, Peter Ujfalusi wrote:
> To facilitate upcoming cleanup in twl stack.
> No functional changes.

Applied, thank you Peter.
 
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/input/misc/twl4030-pwrbutton.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
> index b3dd96d..27c2bc8 100644
> --- a/drivers/input/misc/twl4030-pwrbutton.c
> +++ b/drivers/input/misc/twl4030-pwrbutton.c
> @@ -39,8 +39,7 @@ static irqreturn_t powerbutton_irq(int irq, void *_pwr)
>  	int err;
>  	u8 value;
>  
> -	err = twl_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &value,
> -				STS_HW_CONDITIONS);
> +	err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &value, STS_HW_CONDITIONS);
>  	if (!err)  {
>  		pm_wakeup_event(pwr->dev.parent, 0);
>  		input_report_key(pwr, KEY_POWER, value & PWR_PWRON_IRQ);
> -- 
> 1.8.0
> 
> 

-- 
Dmitry
