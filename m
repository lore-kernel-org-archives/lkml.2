Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab2C0IVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 04:21:19 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35656 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab2C0IVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 04:21:14 -0400
MIME-Version: 1.0
In-Reply-To: <1332450067-16600-1-git-send-email-ddaney.cavm@gmail.com>
References: <1332450067-16600-1-git-send-email-ddaney.cavm@gmail.com>
From: Peter Chen <hzpeterchen@gmail.com>
Date: Tue, 27 Mar 2012 16:20:53 +0800
Message-ID: <CAL411-pe2W3ueDukv6GD-yGGjoc2nxMXOS3+-MU4xsxnyH29Pg@mail.gmail.com>
Subject: Re: [PATCH] usb: Put USB Kconfig items back under USB.
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Julian Wollrath <jwollrath@web.de>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Reported-by: Julian Wollrath <jwollrath@web.de>
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  drivers/usb/Kconfig |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
> index e4405e0..437a77e 100644
> --- a/drivers/usb/Kconfig
> +++ b/drivers/usb/Kconfig
> @@ -2,14 +2,6 @@
>  # USB device configuration
>  #
>
> -menuconfig USB_SUPPORT
> -       bool "USB support"
> -       depends on HAS_IOMEM
> -       default y
> -       ---help---
> -         This option adds core support for Universal Serial Bus (USB).
> -         You will also need drivers from the following menu to make use of it.
> -
>  # many non-PCI SOC chips embed OHCI
>  config USB_ARCH_HAS_OHCI
>        boolean
> @@ -63,6 +55,14 @@ config USB_ARCH_HAS_XHCI
>        boolean
>        default PCI
>
> +menuconfig USB_SUPPORT
> +       bool "USB support"
> +       depends on HAS_IOMEM
> +       default y
> +       ---help---
> +         This option adds core support for Universal Serial Bus (USB).
> +         You will also need drivers from the following menu to make use of it.
> +
>  if USB_SUPPORT
>
>  config USB_COMMON
Yes, it works.

Tested-by: Peter Chen <peter.chen@freescale.com>

> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
BR,
Peter Chen
