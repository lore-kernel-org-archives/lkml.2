Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab2GIDrO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 23:47:14 -0400
Received: from mailgw02.mediatek.com ([218.249.47.111]:39375 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752221Ab2GIDrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 23:47:09 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jul 2012 23:47:08 EDT
From: =?gb2312?B?R2Fvc2VuIFpoYW5nICjVxbjfya0p?= 
	<gaosen.zhang@mediatek.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: "smurf@smurf.noris.de" <smurf@smurf.noris.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 9 Jul 2012 11:39:47 +0800
Subject: RE: USB: option: Add MEDIATEK product ids
Thread-Topic: USB: option: Add MEDIATEK product ids
Thread-Index: Ac1bniKRUNe9UtMMQtWyLlsae84wogB5aecw
Message-ID: <06C943F3F9AAC34D8402DE161B283F7C01ED0CE0@MTKMBS30.mediatek.inc>
References: <CAAwpLmyd2SMR0EKGowDqo54mPUuPmKkziGVTsuRZcrd7i2r2jA@mail.gmail.com>
 <4FF7202B.7090206@mvista.com>
In-Reply-To: <4FF7202B.7090206@mvista.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q693lKVd013738

Dear Shtylyov,
	
	Sorry, I send this patch use web mail(in my mail line not wrapped), I will use git client to send mail again.
	Thank you very much.

BR,
Gaosen

-----Original Message-----
From: Sergei Shtylyov [mailto:sshtylyov@mvista.com] 
Sent: 2012Äê7ÔÂ7ÈÕ 1:28
To: Gaosen Zhang (ÕÅ¸ßÉ­)
Cc: smurf@smurf.noris.de; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: USB: option: Add MEDIATEK product ids

On 07/06/2012 05:50 PM, gaosen wrote:

> From 86fcd5bb701bd927d588386c480c37784d10040a Mon Sep 17 00:00:00 2001
> From: Gaosen Zhang <gaosen.zhang@mediatek.com>
> Date: Fri, 6 Jul 2012 21:44:10 +0800
> Subject: [PATCH 1/1] USB: option: Add MEDIATEK product ids

> Signed-off-by: Gaosen Zhang <gaosen.zhang@mediatek.com>
> ---
>  drivers/usb/serial/option.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c 
> index e668a24..f342a2c 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
[...]
>  	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff, 
> 0x02, 0x01) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff, 
> 0x00, 0x00) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff,
> 0x02, 0x01) },        /* MediaTek MT6276M modem & app port */
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_FP_1COM,
> 0x0a, 0x00, 0x00) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_FP_2COM,
> 0x0a, 0x00, 0x00) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_FPDC_1COM,
> 0x0a, 0x00, 0x00) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_FPDC_2COM,
> 0x0a, 0x00, 0x00) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_DC_1COM,
> 0x0a, 0x00, 0x00) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_DC_5COM,
> 0xff, 0x02, 0x01) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_DC_5COM,
> 0xff, 0x00, 0x00) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_DC_4COM,
> 0xff, 0x02, 0x01) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_DC_4COM,
> 0xff, 0x00, 0x00) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_7208_1COM,
> 0x02, 0x00, 0x00) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MTK_7208_2COM,
> 0x02, 0x02, 0x01) },
>  	{ } /* Terminating entry */
>  };
>  MODULE_DEVICE_TABLE(usb, option_ids);

   Still line wrapped.

WBR, Sergei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
