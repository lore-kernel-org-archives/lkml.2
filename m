Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab1C1FDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 01:03:14 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:42067 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1C1FDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 01:03:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Bzb3iRGZGNsIw1oFFf5Oes9XAv8MLuLMkLjL2o8D2zaTkwJ0tnZmvhPhAJ4RgxbTgh
         QEttoaf+oba1PGQXaa15OnE2B/WRV1iNfBdRojUWcU0wrjuVV4nZBRcWMR/jpekeMaC3
         FDLMRKuM+vMr3rS3tULj2179vHHBp4g81vK+w=
Date: Mon, 28 Mar 2011 13:02:58 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: wanlong.gao@gmail.com
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] Fixed the format error for unnecessary spaces or
 required spaces.
Message-ID: <20110328050256.GB2158@gmail.com>
Mail-Followup-To: wanlong.gao@gmail.com, linux-kernel@vger.kernel.org,
	greg@kroah.com
References: <1301193920-4515-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301193920-4515-1-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 10:45:20AM +0800, wanlong.gao@gmail.com wrote:
> From: Wanlong Gao <wanlong.gao@gmail.com>
> 
> Better has no spaces at the start of a line
> 	FILE: ab3100-core.c:372
> 
> Better has no space before tabs
> 	FILE: adp5520.c:361
> 
> Space required after that ','
> 	FILE: dm355evm_msp.c:97
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  drivers/mfd/ab3100-core.c  |    2 +-
>  drivers/mfd/adp5520.c      |    2 +-
>  drivers/mfd/dm355evm_msp.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
> index 4193af5..010b358 100644
> --- a/drivers/mfd/ab3100-core.c
> +++ b/drivers/mfd/ab3100-core.c
> @@ -369,7 +369,7 @@ EXPORT_SYMBOL(ab3100_event_register);
>  int ab3100_event_unregister(struct ab3100 *ab3100,
>  			    struct notifier_block *nb)
>  {
> -  return blocking_notifier_chain_unregister(&ab3100->event_subscribers,
> +	return blocking_notifier_chain_unregister(&ab3100->event_subscribers,
>  					    nb);
>  }
>  EXPORT_SYMBOL(ab3100_event_unregister);
> diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
> index 3122139..ccf6dc3 100644
> --- a/drivers/mfd/adp5520.c
> +++ b/drivers/mfd/adp5520.c
> @@ -358,7 +358,7 @@ static struct i2c_driver adp5520_driver = {
>  	.remove		= __devexit_p(adp5520_remove),
>  	.suspend	= adp5520_suspend,
>  	.resume		= adp5520_resume,
> -	.id_table 	= adp5520_id,
> +	.id_table	= adp5520_id,
>  };
>  
>  static int __init adp5520_init(void)
> diff --git a/drivers/mfd/dm355evm_msp.c b/drivers/mfd/dm355evm_msp.c
> index 3d4a861..7ebe68b 100644
> --- a/drivers/mfd/dm355evm_msp.c
> +++ b/drivers/mfd/dm355evm_msp.c
> @@ -94,7 +94,7 @@ EXPORT_SYMBOL(dm355evm_msp_read);
>   * Many of the msp430 pins are just used as fixed-direction GPIOs.
>   * We could export a few more of them this way, if we wanted.
>   */
> -#define MSP_GPIO(bit,reg)	((DM355EVM_MSP_ ## reg) << 3 | (bit))
> +#define MSP_GPIO(bit, reg)	((DM355EVM_MSP_ ## reg) << 3 | (bit))
>  
>  static const u8 msp_gpios[] = {
>  	/* eight leds */
> -- 
> 1.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
