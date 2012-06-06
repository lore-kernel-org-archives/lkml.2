Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab2FFPdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:33:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51259 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756172Ab2FFPdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:33:51 -0400
Date: Wed, 6 Jun 2012 11:33:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Namjae Jeon <linkinjeon@gmail.com>
cc: James.Bottomley@HansenPartnership.com, <gregkh@linuxfoundation.org>,
        <mdharm-usb@one-eyed-alien.net>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH 3/3] usb: core: update usb devices for write cache quirk
 in quirk list.
In-Reply-To: <1338985269-9756-1-git-send-email-linkinjeon@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1206061133140.1788-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Namjae Jeon wrote:

> Update Product ID and Vendor ID of Segate Portable HDD and WD My Passport HDD in quirk list.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  drivers/usb/core/quirks.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
> index 32d3adc..624d111 100644
> --- a/drivers/usb/core/quirks.c
> +++ b/drivers/usb/core/quirks.c
> @@ -153,6 +153,12 @@ static const struct usb_device_id usb_quirk_list[] = {
>  	/* INTEL VALUE SSD */
>  	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
>  
> +	/* Seagate Portable Hdd */
> +	{ USB_DEVICE(0x0BC2, 0x2300), .driver_info = USB_QUIRK_WRITE_CACHE },
> +
> +	/* My Passport Hdd (WD) */
> +	{ USB_DEVICE(0x1058, 0x070A), .driver_info = USB_QUIRK_WRITE_CACHE },
> +

These entries belong in drivers/usb/storage/unusual_devs.h, not here.

Alan Stern

