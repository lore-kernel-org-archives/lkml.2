Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab2KDAnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 20:43:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab2KDAnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 20:43:45 -0400
Date: Sun, 4 Nov 2012 01:43:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Johannes Thumshirn <morbidrsa@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        morbidrsa@googlemail.com
Subject: Re: [PATCH] hid-apple.c: Set APPLE_ISO_KEYBOARD at
 USB_DEVICE_ID_APPLE_GEYSER4_HF_ISO
In-Reply-To: <1351935811-4911-1-git-send-email-morbidrsa@googlemail.com>
Message-ID: <alpine.LNX.2.00.1211040143300.24253@pobox.suse.cz>
References: <1351935811-4911-1-git-send-email-morbidrsa@googlemail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2012, Johannes Thumshirn wrote:

> Set APPLE_ISO_KEYBOARD flag on USB_DEVICE_ID_APPLE_GEYSER4_HF_ISO so we get
> the ISO translation on German keyboards for the MacBook4,1 as well.
> 
> Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
> ---
>  drivers/hid/hid-apple.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
> index 06ebdbb..5df5e20 100644
> --- a/drivers/hid/hid-apple.c
> +++ b/drivers/hid/hid-apple.c
> @@ -439,7 +439,8 @@ static const struct hid_device_id apple_devices[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ANSI),
>  		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ISO),
> -		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
> +		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
> +			APPLE_ISO_KEYBOARD },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_JIS),
>  		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
>  			APPLE_RDESC_JIS },

Applied, thanks Johannes.

-- 
Jiri Kosina
SUSE Labs
