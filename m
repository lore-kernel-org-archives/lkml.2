Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257Ab0KPKvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 05:51:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934075Ab0KPKve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:51:34 -0500
Date: Tue, 16 Nov 2010 11:51:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Wu <josh.wu@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux-usb@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH TRIVIAL] AT91: usb: fix typo in atmel_usba_udc driver
In-Reply-To: <1289902493-1821-1-git-send-email-josh.wu@atmel.com>
Message-ID: <alpine.LNX.2.00.1011161149460.7420@pobox.suse.cz>
References: <1289902493-1821-1-git-send-email-josh.wu@atmel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010, Josh Wu wrote:

> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
> fix against 2.6.37-rc1
> 
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
>  		}
>  	}
>  

As this is a compile fix (for bug introduced by 969affff547027), I am 
adding Greg and linux-usb@ to CC. I usually don't push trivial changes 
more than once per release, but this needs to go in faster.

Greg, could you please take it?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
