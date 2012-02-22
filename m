Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab2BVTqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 14:46:55 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43067 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab2BVTqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 14:46:53 -0500
Date: Wed, 22 Feb 2012 14:30:40 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org,
        trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] zd1211rw: Fix typo in zd_usb.c and zd_mac.c
Message-ID: <20120222193039.GC822@tuxdriver.com>
References: <1328801372-2532-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328801372-2532-1-git-send-email-standby24x7@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK

http://mw1.merriam-webster.com/dictionary/resetting

On Fri, Feb 10, 2012 at 12:29:32AM +0900, Masanari Iida wrote:
> Correct spelling "reseting" to "resetting" in
> drivers/net/wireless/zd1211rw/zd_usb.c
> drivers/net/wireless/zd1211rw/zd_mac.c
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/net/wireless/zd1211rw/zd_mac.c |    2 +-
>  drivers/net/wireless/zd1211rw/zd_usb.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
> index 0a70149..a8370eb 100644
> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
> @@ -846,7 +846,7 @@ reset_device:
>  
>  	/* semaphore stuck, reset device to avoid fw freeze later */
>  	dev_warn(zd_mac_dev(mac), "CR_BCN_FIFO_SEMAPHORE stuck, "
> -				  "reseting device...");
> +				  "resetting device...");
>  	usb_queue_reset_device(mac->chip.usb.intf);
>  
>  	return r;
> diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
> index 785bdbe..f766b3e 100644
> --- a/drivers/net/wireless/zd1211rw/zd_usb.c
> +++ b/drivers/net/wireless/zd1211rw/zd_usb.c
> @@ -1104,7 +1104,7 @@ static void zd_tx_watchdog_handler(struct work_struct *work)
>  		goto out;
>  
>  	/* TX halted, try reset */
> -	dev_warn(zd_usb_dev(usb), "TX-stall detected, reseting device...");
> +	dev_warn(zd_usb_dev(usb), "TX-stall detected, resetting device...");
>  
>  	usb_queue_reset_device(usb->intf);
>  
> -- 
> 1.7.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
