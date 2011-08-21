Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab1HUHER (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 03:04:17 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:42138 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901Ab1HUHEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 03:04:16 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Aug 2011 03:04:16 EDT
Date: Sat, 20 Aug 2011 23:57:25 -0700
From: matt mooney <mfm@muteddisk.com>
To: Akshay Joshi <me@akshayjoshi.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: usbip: Fix braces and spaces to match coding style.
Message-ID: <20110821065725.GB27006@haskell.muteddisk.com>
Mail-Followup-To: Akshay Joshi <me@akshayjoshi.com>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1313611112-16083-1-git-send-email-me@akshayjoshi.com> <1313611112-16083-2-git-send-email-me@akshayjoshi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313611112-16083-2-git-send-email-me@akshayjoshi.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:58 Wed 17 Aug     , Akshay Joshi wrote:
> Fix brace positioning and spaces at the start of lines in order to
> comply with the kernel coding style.
> 
> Signed-off-by: Akshay Joshi <me@akshayjoshi.com>

Acked-by: matt mooney <mfm@muteddisk.com>

> ---
>  drivers/staging/usbip/stub_dev.c |    2 +-
>  drivers/staging/usbip/stub_rx.c  |    3 +--
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
> index 1dacdc0..77d6469 100644
> --- a/drivers/staging/usbip/stub_dev.c
> +++ b/drivers/staging/usbip/stub_dev.c
> @@ -548,4 +548,4 @@ struct usb_driver stub_driver = {
>  	.id_table	= stub_table,
>  	.pre_reset	= stub_pre_reset,
>  	.post_reset	= stub_post_reset,
> - };
> +};
> diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
> index 1c1957f..6b4e3e1 100644
> --- a/drivers/staging/usbip/stub_rx.c
> +++ b/drivers/staging/usbip/stub_rx.c
> @@ -179,8 +179,7 @@ static int tweak_reset_device_cmd(struct urb *urb)
>  	 * longer unbinds. This allows the use of synchronous reset.
>  	 */
>  
> -	if (usb_lock_device_for_reset(sdev->udev, sdev->interface)<0)
> -	{
> +	if (usb_lock_device_for_reset(sdev->udev, sdev->interface) < 0) {
>  		dev_err(&urb->dev->dev, "could not obtain lock to reset device\n");
>  		return 0;
>  	}
> -- 
> 1.7.5.4
> 
