Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696Ab2GFMKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:10:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35911 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933366Ab2GFMKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 08:10:49 -0400
Message-ID: <4FF6D59C.7000205@mvista.com>
Date: Fri, 06 Jul 2012 16:10:04 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: gaosen <gaosen.zhang@mediatek.com>
CC: smurf@smurf.noris.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Add MEDIATEK products to option driver
References: <CAAwpLmyKrXk=RwNv2jmaqczJyzUz7TQ808EBr1AQdopor8KGjQ@mail.gmail.com>
In-Reply-To: <CAAwpLmyKrXk=RwNv2jmaqczJyzUz7TQ808EBr1AQdopor8KGjQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05-07-2012 17:49, gaosen wrote:

>  From bb4d2a7155393b5d1207c398c3f9644898588e8a Mon Sep 17 00:00:00 2001
> From: "gaosen.zhang" <gaosen.zhang@mediatek.com>
> Date: Thu, 5 Jul 2012 20:01:54 +0800
> Subject: [PATCH 1/1] Add MEDIATEK products to option driver


> Signed-off-by: gaosen.zhang <gaosen.zhang@mediatek.com>

    Why not simply Gaosen Zhang?

> ---
>   drivers/usb/serial/option.c |   20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)

> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> index e668a24..3d47661 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -496,6 +496,15 @@ static void option_instat_callback(struct urb *urb);
>
>   /* MediaTek products */
>   #define MEDIATEK_VENDOR_ID			0x0e8d
> +#define MEDIATEK_PRODUCT_DC_1COM		0x00a0
> +#define MEDIATEK_PRODUCT_DC_4COM		0x00a5
> +#define MEDIATEK_PRODUCT_DC_5COM		0x00a4
> +#define MEDIATEK_PRODUCT_7208_1COM		0x7101
> +#define MEDIATEK_PRODUCT_7208_2COM		0x7102
> +#define MEDIATEK_PRODUCT_FP_1COM		0x0003
> +#define MEDIATEK_PRODUCT_FP_2COM		0x0023
> +#define MEDIATEK_PRODUCT_FPDC_1COM		0x0043
> +#define MEDIATEK_PRODUCT_FPDC_2COM		0x0033

    Shouldn't these be sorted by numeric value?

> @@ -1233,6 +1242,17 @@ static const struct usb_device_id option_ids[] = {
>   	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff,
> 0x02, 0x01) },
>   	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff,
> 0x00, 0x00) },
>   	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff,
> 0x02, 0x01) },        /* MediaTek MT6276M modem & app port */
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
> MEDIATEK_PRODUCT_DC_1COM, 0x0a, 0x00, 0x00) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
> MEDIATEK_PRODUCT_DC_5COM, 0xff, 0x02, 0x01) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
> MEDIATEK_PRODUCT_DC_5COM, 0xff, 0x00, 0x00) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
> MEDIATEK_PRODUCT_DC_4COM, 0xff, 0x02, 0x01) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
> MEDIATEK_PRODUCT_DC_4COM, 0xff, 0x00, 0x00) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
> MEDIATEK_PRODUCT_7208_1COM, 0x02, 0x00, 0x00) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
> MEDIATEK_PRODUCT_7208_2COM, 0x02, 0x02, 0x01) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
> MEDIATEK_PRODUCT_FP_1COM, 0x0a, 0x00, 0x00) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
> MEDIATEK_PRODUCT_FP_2COM, 0x0a, 0x00, 0x00) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
> MEDIATEK_PRODUCT_FPDC_1COM, 0x0a, 0x00, 0x00) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID,
> MEDIATEK_PRODUCT_FPDC_2COM, 0x0a, 0x00, 0x00) },

    Your patch is line wrapped.

WBR, Sergei
