Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab1BVTUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:20:13 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38542 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab1BVTUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:20:11 -0500
Message-ID: <4D640C0F.3050703@ru.mvista.com>
Date: Tue, 22 Feb 2011 22:18:39 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Shahar Havivi <shaharh@redhat.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org
Subject: Re: [PATCH] USB 10/100 RJ45 Ethernet Network Adapter
References: <20110222140705.GA6055@redhat.com>
In-Reply-To: <20110222140705.GA6055@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Shahar Havivi wrote:

> The device is very similar to (0x0fe6, 0x8101),
> And works well with dm9601 driver.

   You should sign off your patch in order for it to be merged.

> ---
>  drivers/net/usb/dm9601.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)

> diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
> index 02b622e..2d1c8ae 100644
> --- a/drivers/net/usb/dm9601.c
> +++ b/drivers/net/usb/dm9601.c
> @@ -654,6 +654,11 @@ static const struct usb_device_id products[] = {
>  	 USB_DEVICE(0x0a46, 0x9000),	/* DM9000E */
>  	 .driver_info = (unsigned long)&dm9601_info,
>  	 },
> +	{
> +	 USB_DEVICE(0x0fe6, 0x9700),	/* DM9601 USB to Fast Ethernet Adapter */
> +

    Extra empty line shouldn't be here I guess...

> +	 .driver_info = (unsigned long)&dm9601_info,
> +	 },
>  	{},			// END
>  };

WBR, Sergei
