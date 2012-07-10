Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab2GJUmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 16:42:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34237 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab2GJUmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 16:42:11 -0400
Date: Tue, 10 Jul 2012 13:42:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Yuri Khan <yurivkhan@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 1/1] Input: xpad - Handle all variations of Mad Catz
 Beat Pad
Message-ID: <20120710204205.GA31649@core.coreip.homeip.net>
References: <1341592324-665-1-git-send-email-yurivkhan@gmail.com>
 <1341941602-18418-1-git-send-email-yurivkhan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341941602-18418-1-git-send-email-yurivkhan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yuri,

On Wed, Jul 11, 2012 at 12:33:22AM +0700, Yuri Khan wrote:
> * Add this device to usbhid ignore list

Please do not forget your "Signed-off-by: " so that I can apply the
patch.

Thanks.

> ---
>  drivers/hid/hid-core.c        |    1 +
>  drivers/hid/hid-ids.h         |    3 +++
>  drivers/input/joystick/xpad.c |    1 +
>  3 files changed, 5 insertions(+)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 6ac0286..1540934 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1995,6 +1995,7 @@ static const struct hid_device_id hid_ignore_list[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_MCT) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HYBRID) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HEATCONTROL) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_BEATPAD) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1024LS) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1208LS) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICKIT1) },
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index d1cdd2d..43c3d75 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -518,6 +518,9 @@
>  #define USB_DEVICE_ID_CRYSTALTOUCH	0x0006
>  #define USB_DEVICE_ID_CRYSTALTOUCH_DUAL	0x0007
>  
> +#define USB_VENDOR_ID_MADCATZ		0x0738
> +#define USB_DEVICE_ID_MADCATZ_BEATPAD	0x4540
> +
>  #define USB_VENDOR_ID_MCC		0x09db
>  #define USB_DEVICE_ID_MCC_PMD1024LS	0x0076
>  #define USB_DEVICE_ID_MCC_PMD1208LS	0x007a
> diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
> index ee16fb6..16974ef 100644
> --- a/drivers/input/joystick/xpad.c
> +++ b/drivers/input/joystick/xpad.c
> @@ -238,6 +238,7 @@ static struct usb_device_id xpad_table [] = {
>  	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
>  	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech X-Box 360 style controllers */
>  	XPAD_XBOX360_VENDOR(0x0738),		/* Mad Catz X-Box 360 controllers */
> +	{ USB_DEVICE(0x0738, 0x4540) },		/* Mad Catz Beat Pad */
>  	XPAD_XBOX360_VENDOR(0x0e6f),		/* 0x0e6f X-Box 360 controllers */
>  	XPAD_XBOX360_VENDOR(0x12ab),		/* X-Box 360 dance pads */
>  	XPAD_XBOX360_VENDOR(0x1430),		/* RedOctane X-Box 360 controllers */
> -- 
> 1.7.9.5
> 

-- 
Dmitry
