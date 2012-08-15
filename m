Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2HOIjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 04:39:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340Ab2HOIjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 04:39:33 -0400
Date: Wed, 15 Aug 2012 10:39:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: multitouch: Add support for eGalax 0x73f7
In-Reply-To: <1344494088-3438-1-git-send-email-thierry.reding@avionic-design.de>
Message-ID: <alpine.LNX.2.00.1208151039160.7026@pobox.suse.cz>
References: <1344494088-3438-1-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2012, Thierry Reding wrote:

> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
>  drivers/hid/hid-ids.h        | 1 +
>  drivers/hid/hid-multitouch.c | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 5a91bf6..9614a65 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -270,6 +270,7 @@
>  #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72FA	0x72fa
>  #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7302	0x7302
>  #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7349	0x7349
> +#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_73F7	0x73f7
>  #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001	0xa001
>  
>  #define USB_VENDOR_ID_ELECOM		0x056e
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 59c8b5c..115dca2 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -885,6 +885,9 @@ static const struct hid_device_id mt_devices[] = {
>  			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7349) },
>  	{ .driver_data = MT_CLS_EGALAX_SERIAL,
>  		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
> +			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_73F7) },
> +	{ .driver_data = MT_CLS_EGALAX_SERIAL,
> +		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
>  			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) },
>  
>  	/* Elo TouchSystems IntelliTouch Plus panel */

Applied, thanks Thierry.

-- 
Jiri Kosina
SUSE Labs
