Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab2E3W2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 18:28:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238Ab2E3W2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 18:28:35 -0400
Message-ID: <1338416978.8887.31.camel@dcbw.foobar.com>
Subject: Re: [PATCH] USB: option: Updated Huawei K4605 has better id
From: Dan Williams <dcbw@redhat.com>
To: Andrew Bird <ajb@spheresystems.co.uk>
Cc: smurf@smurf.noris.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 30 May 2012 17:29:38 -0500
In-Reply-To: <1338205386-4333-1-git-send-email-ajb@spheresystems.co.uk>
References: <1338205386-4333-1-git-send-email-ajb@spheresystems.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-28 at 12:43 +0100, Andrew Bird wrote:
> Later firmwares for this device now have proper subclass and
> protocol info so we can identify it nicely without needing to use
> the blacklist. I'm not removing the old 0xff matching as there
> may be devices in the field that still need that.

Yay! Somebody in the firmware department got clue...

Dan

> Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
> ---
>  drivers/usb/serial/option.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> index 1aae902..3ac049e 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -666,6 +666,8 @@ static const struct usb_device_id option_ids[] = {
>  	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3806, 0xff, 0xff, 0xff) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4605, 0xff, 0xff, 0xff),
>  		.driver_info = (kernel_ulong_t) &huawei_cdc12_blacklist },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4605, 0xff, 0x01, 0x31) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4605, 0xff, 0x01, 0x32) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0xff, 0x02, 0x31) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0xff, 0x02, 0x32) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3771, 0xff, 0x02, 0x31) },


