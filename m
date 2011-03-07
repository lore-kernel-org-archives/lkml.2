Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab1CGUPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:15:24 -0500
Received: from mail.perches.com ([173.55.12.10]:4137 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab1CGUPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:15:23 -0500
Subject: Re: [PATCH]trivial: Remove one to many r's in some comments.
From: Joe Perches <joe@perches.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1299527103-9953-1-git-send-email-justinmattock@gmail.com>
References: <1299527103-9953-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 12:15:21 -0800
Message-ID: <1299528921.20104.54.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 11:45 -0800, Justin P. Mattock wrote:
> The below patch fixes some typos with one to many "rr's" in a comment.
> PLease have a look and let me know if I missed anything.
> --- a/arch/arm/mach-omap2/smartreflex.c
> +++ b/arch/arm/mach-omap2/smartreflex.c
> @@ -246,7 +246,7 @@ static void sr_stop_vddautocomp(struct omap_sr *sr)
>   * driver register and sr device intializtion API's. Only one call
>   * will ultimately succeed.
>   *
> - * Currenly this function registers interrrupt handler for a particular SR
> + * Currenly this function registers interrupt handler for a particular SR

When you do typo fixes, it'd be good to check the lines
modified to make sure there are no other typos on the
same or nearby lines.

s/intializtion/initialization/
s/Currenly/Currently/


> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index 1758d44..1473476 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -1506,7 +1506,7 @@ void rtl_pci_stop(struct ieee80211_hw *hw)
>  	u8 RFInProgressTimeOut = 0;
>  
>  	/*
> -	 *should before disable interrrupt&adapter
> +	 *should before disable interrupt&adapter

Bad grammar?  Stop HAL before disabling interrupt and adapter?

> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
> index 2fe3046..c5d03e0 100644
> --- a/drivers/usb/musb/musb_gadget.c
> +++ b/drivers/usb/musb/musb_gadget.c
> @@ -699,7 +699,7 @@ static void rxstate(struct musb *musb, struct musb_request *req)
>  	 * most these gadgets, end of is signified either by a short packet,
>  	 * or filling the last byte of the buffer.  (Sending extra data in
>  	 * that last pckate should trigger an overflow fault.)  But in mode 1,

s/pckate/packet/

> diff --git a/include/linux/pxa2xx_ssp.h b/include/linux/pxa2xx_ssp.h
> index 2f691e4..d2d4fb6 100644
> --- a/include/linux/pxa2xx_ssp.h
> +++ b/include/linux/pxa2xx_ssp.h
> @@ -56,7 +56,7 @@
>  /* PXA27x, PXA3xx */
>  #define SSCR0_EDSS	(1 << 20)	/* Extended data size select */
>  #define SSCR0_NCS	(1 << 21)	/* Network clock select */
> -#define SSCR0_RIM	(1 << 22)	/* Receive FIFO overrrun interrupt mask */
> +#define SSCR0_RIM	(1 << 22)	/* Receive FIFO overrun interupt mask */

Fix one, introduce one.  Dangers of s/rr/r/

overrun interrupt.



