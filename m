Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484Ab0J2Myl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 08:54:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:59069 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab0J2Myj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 08:54:39 -0400
Date: Fri, 29 Oct 2010 14:54:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Anton Chikin <kverlin@gmail.com>
Cc: chatty@enac.fr, spbnick@gmail.com, anisse@astier.eu,
        cascardo@holoscopio.com, don@syst.com.br, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        grig@dataart.com, Anton Chikin <Anton.Chikin@dataart.com>,
        Anton Chikin <anton.chikin@dataart.com>
Subject: Re: [PATCH] hid: usbhid: New hid quirks for Panasonic Elite Panaboard
 T-780 and T-880
In-Reply-To: <1288169825-15422-1-git-send-email-Anton.Chikin@dataart.com>
Message-ID: <alpine.LNX.2.00.1010291453460.6879@pobox.suse.cz>
References: <1288169825-15422-1-git-send-email-Anton.Chikin@dataart.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010, Anton Chikin wrote:

> Added Panasonic vendor ID, two device IDs for Panasonic Whiteboard devices and new quirk to ignore
> these devices in hid-core driver.

Could you please be more verbose in the changelog?

Is the generic HID driver not working with these devices at all? Or is the 
functionality only limited, not exploiting all the features the hardware 
provides?

Is there any other driver available for these devices?

Thanks.

> 
> Signed-off-by: Anton Chikin <anton.chikin@dataart.com>
> ---
>  drivers/hid/hid-ids.h           |    4 ++++
>  drivers/hid/usbhid/hid-quirks.c |    2 ++
>  2 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 3341baa..b5542d3 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -446,6 +446,10 @@
>  #define USB_VENDOR_ID_ORTEK		0x05a4
>  #define USB_DEVICE_ID_ORTEK_WKB2000	0x2000
>  
> +#define USB_VENDOR_ID_PANASONIC 	0x04da
> +#define USB_DEVICE_ID_PANASONIC_PANABOARD_T780 	0x1044
> +#define USB_DEVICE_ID_PANASONIC_PANABOARD_T880	0x104d 
> +
>  #define USB_VENDOR_ID_PANJIT		0x134c
>  
>  #define USB_VENDOR_ID_PANTHERLORD	0x0810
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
> index 2c18547..b5788b0 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -65,6 +65,8 @@ static const struct hid_blacklist {
>  	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_AXIS_295, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_DMI, USB_DEVICE_ID_DMI_ENC, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
> +	{ USB_VENDOR_ID_PANASONIC, USB_DEVICE_ID_PANASONIC_PANABOARD_T780, HID_QUIRK_IGNORE },
> +	{ USB_VENDOR_ID_PANASONIC, USB_DEVICE_ID_PANASONIC_PANABOARD_T880, HID_QUIRK_IGNORE },
>  	{ USB_VENDOR_ID_PRODIGE, USB_DEVICE_ID_PRODIGE_CORDLESS, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_SUN, USB_DEVICE_ID_RARITAN_KVM_DONGLE, HID_QUIRK_NOGET },
> -- 
> 1.7.0.4
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
