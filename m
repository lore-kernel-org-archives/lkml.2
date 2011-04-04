Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1DDJGC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:06:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab1DDJGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:06:01 -0400
Date: Mon, 4 Apr 2011 11:05:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Unavowed <unavowed@vexillium.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Add NOGET quirk for the CH Pro Throttle
In-Reply-To: <4d988b60.29c6ec0a.0716.ffffa4bf@mx.google.com>
Message-ID: <alpine.LNX.2.00.1104041105250.28516@pobox.suse.cz>
References: <4d988b60.29c6ec0a.0716.ffffa4bf@mx.google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Apr 2011, Unavowed wrote:

> The CH Pro Throttle needs the NOGET quirk flag to work, just like other CH
> Products devices which already have the flag set.
> 
> Signed-off-by: Unavowed <unavowed@vexillium.org>

Hi,

thanks a lot for the patch.

Would it please be possible to have a real name to attribute for patch 
authorship and Signed-off-by line?

> ---
>  drivers/hid/hid-ids.h           |    1 +
>  drivers/hid/usbhid/hid-quirks.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 65ac53d..1a9f996 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -150,6 +150,7 @@
>  #define USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6 0x0f01
>  
>  #define USB_VENDOR_ID_CH		0x068e
> +#define USB_DEVICE_ID_CH_PRO_THROTTLE	0x00f1
>  #define USB_DEVICE_ID_CH_PRO_PEDALS	0x00f2
>  #define USB_DEVICE_ID_CH_COMBATSTICK	0x00f4
>  #define USB_DEVICE_ID_CH_FLIGHT_SIM_ECLIPSE_YOKE       0x0051
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
> index 9a94b64..a8426f1 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -59,6 +59,7 @@ static const struct hid_blacklist {
>  	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_COMBATSTICK, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_FLIGHT_SIM_ECLIPSE_YOKE, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_FLIGHT_SIM_YOKE, HID_QUIRK_NOGET },
> +	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_THROTTLE, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_PEDALS, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_3AXIS_5BUTTON_STICK, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_AXIS_295, HID_QUIRK_NOGET },
> -- 
> 1.7.3.4
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
