Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0KSRIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 12:08:47 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55310 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab0KSRIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 12:08:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IRi751Fbh/4VVR3u3oFQ7qVK2Zc33xkDwBijL6KXuxQxHlQGm2TfcSu3bSoIxuncqt
         fpFSaUGdVGkFPJb5iHtNUy2VCEdfcmJAlMp/l+URBmfJCkP6L0JcFIQSnLTQbNGkUBZ4
         CZORRPkj0gTdQ5YlqDb6DtgOUCh7dGdFx1bqA=
Date: Fri, 19 Nov 2010 09:08:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Glenn Sommer <gsommer@datanordisk.dk>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        linux-input@vger.kernel.org
Subject: Re: Patch for LG Flatron T1710B touchscreen
Message-ID: <20101119170837.GC6236@core.coreip.homeip.net>
References: <4CE63CC7.9040709@datanordisk.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE63CC7.9040709@datanordisk.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 10:00:55AM +0100, Glenn Sommer wrote:
> I've recently got my hands on a LG Flatron T1710B touchscreen.
> As other LG products, this seems to use the ITM panel.
> 
> I've patches my kernel to use the ITM driver with this device, and it seems to work great.
> 

Glenn,

I need you "Signed-off-by: ..." so I can apply the patch.

Thank you.

> --- PATCH START ---
> 
> --- drivers/input/touchscreen/usbtouchscreen.c.orig	2010-11-18 16:33:40.806381557 +0100
> +++ drivers/input/touchscreen/usbtouchscreen.c	2010-11-19 09:40:13.909222383 +0100
> @@ -173,6 +173,7 @@ static struct usb_device_id usbtouch_dev
> 
>  #ifdef CONFIG_TOUCHSCREEN_USB_ITM
>  	{USB_DEVICE(0x0403, 0xf9e9), .driver_info = DEVTYPE_ITM},
> +	{USB_DEVICE(0x16e3, 0xf9e9), .driver_info = DEVTYPE_ITM},
>  #endif
> 
>  #ifdef CONFIG_TOUCHSCREEN_USB_ETURB
> 
> --- PATCH END ---
> 
> -- 
> Med venlig hilsen / Best regards
> Data Nordisk
> 
> Glenn Sommer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Dmitry
