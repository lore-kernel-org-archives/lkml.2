Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab0JTGe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:34:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58939 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab0JTGe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:34:27 -0400
Date: Wed, 20 Oct 2010 09:34:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        "Balbi, Felipe" <balbi@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 1/3] usb: fix Kconfig warning
Message-ID: <20101020063405.GF15448@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
 <1287482608-11320-2-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1287482608-11320-2-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 05:03:26AM -0500, Felipe Contreras wrote:
>warning: (USB_MUSB_HDRC_HCD && USB_SUPPORT && USB_MUSB_HDRC &&
>(USB_MUSB_HOST || USB_MUSB_OTG) && USB_GADGET_MUSB_HDRC || USB_MUSB_OTG
>&& <choice> && USB && USB_GADGET && PM && EXPERIMENTAL) selects USB_OTG
>which has unmet direct dependencies (USB_GADGET_OMAP && ARCH_OMAP_OTG &&
>USB_OHCI_HCD)
>
>This doesn't seem to happen on 2.6.36-rc8, but still doesn't make sense
>to keep this duplicated config that is already defined in usb/core.
>

Acked-by: Felipe Balbi <balbi@ti.com>

>Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>---
> drivers/usb/gadget/Kconfig |   11 -----------
> 1 files changed, 0 insertions(+), 11 deletions(-)
>
>diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
>index cd27f9b..19a6eb6 100644
>--- a/drivers/usb/gadget/Kconfig
>+++ b/drivers/usb/gadget/Kconfig
>@@ -209,17 +209,6 @@ config USB_OMAP
> 	default USB_GADGET
> 	select USB_GADGET_SELECTED
>
>-config USB_OTG
>-	boolean "OTG Support"
>-	depends on USB_GADGET_OMAP && ARCH_OMAP_OTG && USB_OHCI_HCD
>-	help
>-	   The most notable feature of USB OTG is support for a
>-	   "Dual-Role" device, which can act as either a device
>-	   or a host.  The initial role choice can be changed
>-	   later, when two dual-role devices talk to each other.
>-
>-	   Select this only if your OMAP board has a Mini-AB connector.
>-
> config USB_GADGET_PXA25X
> 	boolean "PXA 25x or IXP 4xx"
> 	depends on (ARCH_PXA && PXA25x) || ARCH_IXP4XX
>-- 
>1.7.3.1.2.g7fe2b

-- 
balbi
