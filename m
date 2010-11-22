Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab0KVHTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 02:19:53 -0500
Received: from smtpeu1.atmel.com ([195.65.72.27]:58218 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab0KVHTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 02:19:52 -0500
Subject: Re: [PATCH 2/2] [AVR32] Fix typo in atmel_usba_udc.c
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Sven Schnelle <svens@stackframe.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1290382087-3849-3-git-send-email-svens@stackframe.org>
References: <1290382087-3849-1-git-send-email-svens@stackframe.org>
	 <1290382087-3849-3-git-send-email-svens@stackframe.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 22 Nov 2010 08:19:44 +0100
Message-ID: <1290410384.2833.27.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Nov 2010 07:19:47.0892 (UTC) FILETIME=[A5178740:01CB8A15]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 00:28 +0100, Sven Schnelle wrote: 
> It should be 'udc' not 'ubc' in usba_udc_probe()
> 
> Signed-off-by: Sven Schnelle <svens@stackframe.org>
> ---
>  drivers/usb/gadget/atmel_usba_udc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
> index b5e20e8..717ff65 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/atmel_usba_udc.c
> @@ -2017,7 +2017,7 @@ static int __init usba_udc_probe(struct platform_device *pdev)
>  			}
>  		} else {
>  			/* gpio_request fail so use -EINVAL for gpio_is_valid */
> -			ubc->vbus_pin = -EINVAL;
> +			udc->vbus_pin = -EINVAL;

Nice catch, please send this through the USB mailing list, it is not
specific to AVR32.

-- 
Hans-Christian Egtvedt


