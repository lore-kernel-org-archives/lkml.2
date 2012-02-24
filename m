Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab2BXLcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 06:32:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59082 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab2BXLcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 06:32:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of sshtylyov@mvista.com designates 10.204.156.5 as permitted sender) smtp.mail=sshtylyov@mvista.com
Message-ID: <4F477515.1040303@mvista.com>
Date: Fri, 24 Feb 2012 15:31:33 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: meng zhang <meng.zhang@mediatek.com>
CC: smurf@smurf.noris.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: option: Add MediaTek MT6276M modem&app interfaces
References: <CACwCHpxjhEenzv+H3zK2cNKAA9KyuK=DPythY2UgHTmY_AhqaQ@mail.gmail.com>
In-Reply-To: <CACwCHpxjhEenzv+H3zK2cNKAA9KyuK=DPythY2UgHTmY_AhqaQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-02-2012 10:41, meng zhang wrote:

> from: Meng Zhang<meng.zhang@mediatek.com>

> 1. This patch is based on kernel 3.0.0

    You should base on the recent kernel instead.

> 2. To declare the product IDs in option.c

> Signed-off-by: Meng Zhang<meng.zhang@mediatek.com>
> ---------------------------------------------------------------------------------------

    This line is not needed here.

> --- option.c	2012-02-23 10:42:40.635138657 +0800
> +++ option.c.orig	2011-10-07 22:50:04.000000000 +0800

    The patch should be applicablke with -p1 switch, i.e. based on the linux 
source root.

[...]
> @@ -1008,10 +1005,6 @@ static const struct usb_device_id option
>   	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650
> CDMA 450 1xEVDO modem */
>   	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
>   	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID,
> SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /*
> Samsung GT-B3730 LTE USB modem.*/
> -	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff,
> 0x00, 0x00) },

    You're not adding the device IDs, you're removing them.

> -	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff,
> 0x02, 0x01) },
> -	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff,
> 0x00, 0x00) },
> -	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff,
> 0x02, 0x01) },	/* MediaTek MT6276M modem&  app port */

    The patch is line wrapped.

WBR, Sergei
