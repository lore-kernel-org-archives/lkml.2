Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2B0LH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 06:07:58 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60202 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2B0LH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 06:07:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of sshtylyov@mvista.com designates 10.204.156.207 as permitted sender) smtp.mail=sshtylyov@mvista.com
Message-ID: <4F4B63BD.6070602@mvista.com>
Date: Mon, 27 Feb 2012 15:06:37 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: =?UTF-8?B?Ik1lbmcgWmhhbmcgKOW8oOiQjCki?= <Meng.Zhang@mediatek.com>
CC: "smurf@smurf.noris.de" <smurf@smurf.noris.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: option: Add MediaTek MT6276M modem&app interfaces
References: <0D3EFCAF29FAA54FB91286E54DF1085C2304850460@MTKMBS30.mediatek.inc>
In-Reply-To: <0D3EFCAF29FAA54FB91286E54DF1085C2304850460@MTKMBS30.mediatek.inc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 27-02-2012 8:11, Meng Zhang (张萌) wrote:

> 1. To declare the product IDs in option.c
> 2. Please pull from
> 	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>     to get these changes

    This patch is not yet there. :-)

> Signed-off-by: Meng Zhang<meng.zhang@mediatek.com>
> ---------------------------------------------------------------------------------------

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
>                  OPTION_BLACKLIST_NONE = 0,
> @@ -1198,6 +1201,10 @@ static const struct usb_device_id option_ids[] = {
>          { USB_DEVICE_AND_INTERFACE_INFO(VIETTEL_VENDOR_ID, VIETTEL_PRODUCT_VT1000, 0xff, 0xff, 0xff) },
>          { USB_DEVICE_AND_INTERFACE_INFO(ZD_VENDOR_ID, ZD_PRODUCT_7000, 0xff, 0xff, 0xff) },
>          { USB_DEVICE(LG_VENDOR_ID, LG_PRODUCT_L02C) }, /* docomo L-02C modem */
> +       { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff, 0x00, 0x00) },
> +       { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff, 0x02, 0x01) },
> +       { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff, 0x00, 0x00) },
> +       { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff, 0x02, 0x01) },        /* MediaTek MT6276M modem&  app port */

    All tabs in the patch were converted to spaces.

WBR, Sergei
