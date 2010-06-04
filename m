Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0FDJRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 05:17:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab0FDJRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 05:17:09 -0400
Date: Fri, 4 Jun 2010 11:17:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Micki Balanga <micki@n-trig.com>
Cc: chatty@enac.fr, dhprince-devel@yahoo.co.uk, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH] HID: Add support to new N-trig firwmare
In-Reply-To: <48A28051AC6D7A48B64F28272458190333674B@Exchange-IL.n-trig.com>
Message-ID: <alpine.LNX.2.00.1006041115480.12271@pobox.suse.cz>
References: <48A28051AC6D7A48B64F28272458190333674B@Exchange-IL.n-trig.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010, Micki Balanga wrote:

> Update hid-ids.h to support new N-trig firmware.
> Product id  0x02 - 0x0A

[ adding Rafi Rubin to CC ]

Hi Micki,

thanks a lot for the update. Your mail client line-wrapped the patch 
though, so I couldn't apply it without having to fix all the wrapped lines 
manually. Could you please fix it and resend? (or send it as attachment if 
your mail client can't be configured not to damage the patch if put 
in-line)?

Thanks.

> Signed-off-by: Micki Balanga <micki@n-trig.com>
> ---
> ---
>  drivers/hid/hid-core.c |    9 +++++++++
>  drivers/hid/hid-ids.h  |   10 ++++++++++
>  2 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index aa0f7dc..19f627a 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1337,6 +1337,15 @@ static const struct hid_device_id hid_blacklist[]
> = {
>         { HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT,
> USB_DEVICE_ID_WIRELESS_OPTICAL_DESKTOP_3_0) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_MONTEREY,
> USB_DEVICE_ID_GENIUS_KB29E) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
> USB_DEVICE_ID_NTRIG_TOUCH_SCREEN) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
> USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_1) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
> USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_2) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
> USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_3) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
> USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_4) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
> USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_5) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
> USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_6) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
> USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_7) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
> USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_8) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_NTRIG,
> USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_9) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_ORTEK,
> USB_DEVICE_ID_ORTEK_WKB2000) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX,
> USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_QUANTA,
> USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 6af77ed..55fbfd6 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -391,6 +391,16 @@
> 
>  #define USB_VENDOR_ID_NTRIG                0x1b96
>  #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN   0x0001
> +#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_1 0x0002
> +#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_2 0x0003
> +#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_3 0x0004
> +#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_4 0x0005
> +#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_5 0x0006
> +#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_6 0x0007
> +#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_7 0x0008
> +#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_8 0x0009
> +#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_9 0x000A
> +
> 
>  #define USB_VENDOR_ID_ONTRAK           0x0a07
>  #define USB_DEVICE_ID_ONTRAK_ADU100    0x0064
> -- 
> 1.6.3.3
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
