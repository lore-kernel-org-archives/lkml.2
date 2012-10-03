Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833Ab2JCQQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:16:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51453 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932984Ab2JCQQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:16:25 -0400
Date: Wed, 3 Oct 2012 12:16:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Fainelli <florian@openwrt.org>
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, Felipe Balbi <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/25] USB: ehci: remove CNS3xxx EHCI platform driver
In-Reply-To: <1349276601-8371-13-git-send-email-florian@openwrt.org>
Message-ID: <Pine.LNX.4.44L0.1210031215280.1441-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2012, Florian Fainelli wrote:

> The users have been converted to use the ehci platform driver instead.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>

> --- a/drivers/usb/host/ehci-hcd.c
> +++ b/drivers/usb/host/ehci-hcd.c
> @@ -1254,16 +1254,6 @@ MODULE_LICENSE ("GPL");
>  #define	PLATFORM_DRIVER		ehci_atmel_driver
>  #endif
>  
> -#ifdef CONFIG_USB_OCTEON_EHCI
> -#include "ehci-octeon.c"
> -#define PLATFORM_DRIVER		ehci_octeon_driver
> -#endif

Looks like this crept in here by mistake.  It belong in patch 10/25.

Alan Stern

