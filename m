Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab1HBVmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 17:42:32 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43286 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab1HBVmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 17:42:23 -0400
Message-ID: <4E386F3B.9050901@lwfinger.net>
Date: Tue, 02 Aug 2011 16:42:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: John W Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl8192cu: add USB ID for Belkin n300 Micro USB wireless
 adapter
References: <201108022229.58532.s.L-H@gmx.de>
In-Reply-To: <201108022229.58532.s.L-H@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 03:29 PM, Stefan Lippers-Hollmann wrote:
> Signed-off-by: Stefan Lippers-Hollmann<s.l-h@gmx.de>
> Cc: stable<stable@kernel.org>  [2.6.39+]
> ---
>   drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |    3 +++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> @@ -322,6 +322,9 @@ static struct usb_device_id rtl8192c_usb
>   	{RTL_USB_DEVICE(0x2001, 0x330a, rtl92cu_hal_cfg)}, /*D-Link-Alpha*/
>   	{RTL_USB_DEVICE(0x2019, 0xab2b, rtl92cu_hal_cfg)}, /*Planex -Abocom*/
>   	{RTL_USB_DEVICE(0x7392, 0x7822, rtl92cu_hal_cfg)}, /*Edimax -Edimax*/
> +
> +	/****** 8192CUS Dongle ********/
> +	{RTL_USB_DEVICE(0x050D, 0x2103, rtl92cu_hal_cfg)}, //Belkin - Edimax
>   	{}
>   };

NACK. That C++ comment should be fixed.

See my response to the second Email for more discussion.

Larry
