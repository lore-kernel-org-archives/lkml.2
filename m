Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab1GKPTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 11:19:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab1GKPTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 11:19:39 -0400
Date: Mon, 11 Jul 2011 17:19:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Ice.Chien" <ice.chien@accupoint.com.tw>
Cc: linux-kernel@vger.kernel.org, benjamin.tissoires@enac.fr,
        Jonson Wu <jonson.wu@accupoint.com.tw>
Subject: Re: [PATCH] hid-multitouch driver: add one new hid multitouch device's
 VID/PID
In-Reply-To: <C3F4720C7083254FAB01F1C177F02212098A1B@exsvr1.accupoint.com.tw>
Message-ID: <alpine.LRH.2.00.1107111718100.31445@twin.jikos.cz>
References: <[PATCH 2/2]Staging: comedi: fix brace coding style issue in pcl818.c> <1310362809-15273-1-git-send-email-ravishankarkm32@gmail.com> <C3F4720C7083254FAB01F1C177F02212098A1B@exsvr1.accupoint.com.tw>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, Ice.Chien wrote:

> This is a patch to add one hid multitouch device's VID/PID in hid-ids.h
> and hid-core.c
> 
> Signed-off-by: Ice Chien <ice.chien@accupoint.com.tw>
> ---
> diff -u ./linux-2.6.39.3/drivers/hid//hid-core.c
> ./modified/drivers/hid//hid-core.c
> --- ./linux-2.6.39.3/drivers/hid//hid-core.c	2011-07-09
> 14:16:06.000000000 +0800
> +++ ./modified/drivers/hid//hid-core.c	2011-07-11 13:36:07.784957908
> +0800
> @@ -1482,6 +1482,7 @@
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP,
> USB_DEVICE_ID_WALTOP_SLIM_TABLET_12_1_INCH) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP,
> USB_DEVICE_ID_WALTOP_MEDIA_TABLET_10_6_INCH) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP,
> USB_DEVICE_ID_WALTOP_MEDIA_TABLET_14_1_INCH) },
> +      	{ HID_USB_DEVICE(USB_VENDOR_ID_XAT, USB_DEVICE_ID_XAT_CSR) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ZYDACRON,
> USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL) },
> diff -u ./linux-2.6.39.3/drivers/hid//hid-ids.h
> ./modified/drivers/hid//hid-ids.h
> --- ./linux-2.6.39.3/drivers/hid//hid-ids.h	2011-07-09
> 14:16:06.000000000 +0800
> +++ ./modified/drivers/hid//hid-ids.h	2011-07-11 13:36:05.969865971
> +0800
> @@ -607,6 +607,9 @@
>  #define USB_VENDOR_ID_WISEGROUP_LTD2	0x6677
>  #define USB_DEVICE_ID_SMARTJOY_DUAL_PLUS 0x8802
>  
> +#define USB_VENDOR_ID_XAT               0x2505
> +#define USB_DEVICE_ID_XAT_CSR           0x0220
> +
>  #define USB_VENDOR_ID_YEALINK		0x6993
>  #define USB_DEVICE_ID_YEALINK_P1K_P4K_B2K	0xb001
>  
> Common subdirectories: ./linux-2.6.39.3/drivers/hid//usbhid and
> ./modified/drivers/hid//usbhid

Hi,

first, your patch is line-wrapped and whitespace damaged. Please fix your 
mailclient (*) for your future (re-)submissions.

Second, the patch seems incomplete. You probably want some specific driver 
(persumably hid-multitouch?) to claim the device.

(*) see Documentation/email-clients.txt for details.

-- 
Jiri Kosina
SUSE Labs

