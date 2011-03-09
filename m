Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab1CIVN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 16:13:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36932 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab1CIVN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 16:13:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Zob5IAa5o0PMPIxcn65m4k9pZZpWQLWD3KMR9zmeGwm9zjD0DKtau/ZeaXhGS77FLK
         PhVtpNyIV+WvV/N6ec5uKIR27PhK05eRwvQ4at0akj7uH8axRJUGcK8DbOh3D5rsDF0u
         bKGt9kErNwUU6kVZqP+PdLybn2ceng0ySA4sI=
Date: Wed, 9 Mar 2011 22:13:20 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Jean-Francois Argentino <jf.argentino@osean.fr>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] ftdi_sio: adding support for OLIMEX ARM-USB-OCD-H
Message-ID: <20110309211320.GB14009@localhost>
References: <4D6BC4CB.6050602@osean.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6BC4CB.6050602@osean.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 04:52:43PM +0100, Jean-Francois Argentino wrote:
> from JF Argentino <jf.argentino@free.fr>
> 
> Adding support for the OLIMEX ARM-USB-OCD-H JTAG device (id 15ba:002b) 
> based on FTDI FT2232H
> Signed-off-by: JF Argentino <jf.argentino@free.fr>

Look good, but please send this patch directly to Greg KH and CC
linux-usb as well.

Thanks,
Johan


> --- linux-2.6.37.2/drivers/usb/serial/ftdi_sio_ids.h	2011-02-25 
> 00:09:00.000000000 +0100
> +++ linux/drivers/usb/serial/ftdi_sio_ids.h	2011-02-28 
> 15:42:19.000000000 +0100
> @@ -730,6 +730,7 @@
>   /* Olimex */
>   #define OLIMEX_VID			0x15BA
>   #define OLIMEX_ARM_USB_OCD_PID		0x0003
> +#define OLIMEX_ARM_USB_OCD_H_PID	0x002b
> 
>   /*
>    * Telldus Technologies
> --- linux-2.6.37.2/drivers/usb/serial/ftdi_sio.c	2011-02-25 
> 00:09:00.000000000 +0100
> +++ linux/drivers/usb/serial/ftdi_sio.c	2011-02-28 16:27:02.000000000 +0100
> @@ -721,6 +721,8 @@ static struct usb_device_id id_table_com
>   	{ USB_DEVICE(FTDI_VID, FTDI_PROPOX_JTAGCABLEII_PID) },
>   	{ USB_DEVICE(OLIMEX_VID, OLIMEX_ARM_USB_OCD_PID),
>   		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
> +	{ USB_DEVICE(OLIMEX_VID, OLIMEX_ARM_USB_OCD_H_PID),
> +		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
>   	{ USB_DEVICE(FIC_VID, FIC_NEO1973_DEBUG_PID),
>   		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
>   	{ USB_DEVICE(FTDI_VID, FTDI_OOCDLINK_PID),
