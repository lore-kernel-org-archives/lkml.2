Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2B0L6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 06:58:13 -0500
Received: from mailgw01.mediatek.com ([218.249.47.110]:53189 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751541Ab2B0L6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 06:58:12 -0500
From: =?utf-8?B?TWVuZyBaaGFuZyAo5byg6JCMKQ==?= <Meng.Zhang@mediatek.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>,
        "smurf@smurf.noris.de" <smurf@smurf.noris.de>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 27 Feb 2012 19:57:59 +0800
Subject: RE: [PATCH] USB: option: Add MediaTek MT6276M modem&app interfaces
Thread-Topic: [PATCH] USB: option: Add MediaTek MT6276M modem&app interfaces
Thread-Index: Acz1QBMGtJSlYr8TR5WUYxiduFlD/wABksbw
Message-ID: <0D3EFCAF29FAA54FB91286E54DF1085C2304850551@MTKMBS30.mediatek.inc>
References: <0D3EFCAF29FAA54FB91286E54DF1085C2304850460@MTKMBS30.mediatek.inc>
 <4F4B63BD.6070602@mvista.com>
In-Reply-To: <4F4B63BD.6070602@mvista.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1RBwLWf017982

Dear both,

Sorry I'm still a rookie in kernel patching, and should I commit this change by myself or let owner (hi, Matthias) do it?

Thanks~

BR.
Meng Zhang

-----Original Message-----
From: Sergei Shtylyov [mailto:sshtylyov@mvista.com] 
Sent: Monday, February 27, 2012 7:07 PM
To: Meng Zhang (å¼ èŒ)
Cc: smurf@smurf.noris.de; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: option: Add MediaTek MT6276M modem&app interfaces

Hello.

On 27-02-2012 8:11, Meng Zhang (å¼ èŒ) wrote:

> 1. To declare the product IDs in option.c 2. Please pull from
> 	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>     to get these changes

    This patch is not yet there. :-)

> Signed-off-by: Meng Zhang<meng.zhang@mediatek.com>
> ----------------------------------------------------------------------
> -----------------

    This line is not needed. If you want a sperator, use --- instead.

> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c 
> index b54afce..7069f9d 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -484,6 +484,9 @@ static void option_instat_callback(struct urb *urb);
>   #define LG_VENDOR_ID                           0x1004
>   #define LG_PRODUCT_L02C                                0x618f
>
> +/* MediaTek products */
> +#define MEDIATEK_VENDOR_ID                     0x0e8d
> +
>   /* some devices interfaces need special handling due to a number of reasons */
>   enum option_blacklist_reason {
>                  OPTION_BLACKLIST_NONE = 0, @@ -1198,6 +1201,10 @@ 
> static const struct usb_device_id option_ids[] = {
>          { USB_DEVICE_AND_INTERFACE_INFO(VIETTEL_VENDOR_ID, VIETTEL_PRODUCT_VT1000, 0xff, 0xff, 0xff) },
>          { USB_DEVICE_AND_INTERFACE_INFO(ZD_VENDOR_ID, ZD_PRODUCT_7000, 0xff, 0xff, 0xff) },
>          { USB_DEVICE(LG_VENDOR_ID, LG_PRODUCT_L02C) }, /* docomo 
> L-02C modem */
> +       { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff, 0x00, 0x00) },
> +       { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff, 0x02, 0x01) },
> +       { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff, 0x00, 0x00) },
> +       { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff, 0x02, 0x01) },        /* MediaTek MT6276M modem&  app port */

    All tabs in the patch were converted to spaces.

WBR, Sergei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
