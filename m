Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1HUHD3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 03:03:29 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:53092
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901Ab1HUHD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 03:03:27 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Aug 2011 03:03:27 EDT
Date: Sat, 20 Aug 2011 23:56:35 -0700
From: matt mooney <mfm@muteddisk.com>
To: Akshay Joshi <me@akshayjoshi.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: usbip: Remove trailing spaces.
Message-ID: <20110821065635.GA27006@haskell.muteddisk.com>
Mail-Followup-To: Akshay Joshi <me@akshayjoshi.com>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1313611112-16083-1-git-send-email-me@akshayjoshi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313611112-16083-1-git-send-email-me@akshayjoshi.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:58 Wed 17 Aug     , Akshay Joshi wrote:
> Remove trailing spaces to comply with the kernel coding style.
> 
> Signed-off-by: Akshay Joshi <me@akshayjoshi.com>

Acked-by: matt mooney <mfm@muteddisk.com>

> ---
>  drivers/staging/usbip/stub_dev.c |    4 ++--
>  drivers/staging/usbip/stub_rx.c  |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
> index fce22f2..1dacdc0 100644
> --- a/drivers/staging/usbip/stub_dev.c
> +++ b/drivers/staging/usbip/stub_dev.c
> @@ -524,11 +524,11 @@ static void stub_disconnect(struct usb_interface *interface)
>  	}
>  }
>  
> -/* 
> +/*
>   * Presence of pre_reset and post_reset prevents the driver from being unbound
>   * when the device is being reset
>   */
> - 
> +
>  int stub_pre_reset(struct usb_interface *interface)
>  {
>  	dev_dbg(&interface->dev, "pre_reset\n");
> diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
> index 538fb9e..1c1957f 100644
> --- a/drivers/staging/usbip/stub_rx.c
> +++ b/drivers/staging/usbip/stub_rx.c
> @@ -175,7 +175,7 @@ static int tweak_reset_device_cmd(struct urb *urb)
>  	dev_info(&urb->dev->dev, "usb_queue_reset_device\n");
>  
>  	/*
> -	 * With the implementation of pre_reset and post_reset the driver no 
> +	 * With the implementation of pre_reset and post_reset the driver no
>  	 * longer unbinds. This allows the use of synchronous reset.
>  	 */
>  
> -- 
> 1.7.5.4
> 
