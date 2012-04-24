Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2DXF27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 01:28:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64906 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab2DXF2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 01:28:43 -0400
Date: Mon, 23 Apr 2012 22:28:32 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/input/tablet/aiptek.c: adjust error-handling
 code label
Message-ID: <20120424052832.GA28787@core.coreip.homeip.net>
References: <1334609092-15338-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334609092-15338-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 10:44:52PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> At the point of this error-handling code, aiptek->urb has been allocated,
> and it does not appear to be less necessary to free it here than in the
> error-handling code just below.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied, thank you Julia.

> 
> ---
>  drivers/input/tablet/aiptek.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
> index 205d16a..a33d347 100644
> --- a/drivers/input/tablet/aiptek.c
> +++ b/drivers/input/tablet/aiptek.c
> @@ -1856,7 +1856,7 @@ aiptek_probe(struct usb_interface *intf, const struct usb_device_id *id)
>  	if (i == ARRAY_SIZE(speeds)) {
>  		dev_info(&intf->dev,
>  			 "Aiptek tried all speeds, no sane response\n");
> -		goto fail2;
> +		goto fail3;
>  	}
>  
>  	/* Associate this driver's struct with the usb interface.
> 

-- 
Dmitry
