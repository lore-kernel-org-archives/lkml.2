Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab0JSIP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:15:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39811 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab0JSIP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:15:26 -0400
Date: Tue, 19 Oct 2010 11:15:09 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: [PATCH 2/3] usb: trivial Kconfig cleanups
Message-ID: <20101019081509.GH12470@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1287475466-8927-1-git-send-email-felipe.contreras@gmail.com>
 <1287475466-8927-3-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1287475466-8927-3-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

On Tue, Oct 19, 2010 at 03:04:25AM -0500, Felipe Contreras wrote:
>@@ -125,14 +125,6 @@ config USB_MUSB_OTG
>
> endchoice
>
>-# enable peripheral support (including with OTG)
>-config USB_GADGET_MUSB_HDRC
>-	bool
>-	depends on USB_MUSB_HDRC && (USB_MUSB_PERIPHERAL || USB_MUSB_OTG)
>-#	default y
>-#	select USB_GADGET_DUALSPEED
>-#	select USB_GADGET_SELECTED
>-

$ git grep -e CONFIG_USB_GADGET_MUSB_HDRC drivers/usb/
drivers/usb/gadget/gadget_chips.h:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/Makefile:ifeq ($(CONFIG_USB_GADGET_MUSB_HDRC),y)
drivers/usb/musb/am35x.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/da8xx.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/musb_core.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/musb_core.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/musb_core.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/musb_core.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/musb_core.c:#endif /* CONFIG_USB_GADGET_MUSB_HDRC */
drivers/usb/musb/musb_core.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/musb_core.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/musb_core.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/musb_core.c:#elif defined(CONFIG_USB_GADGET_MUSB_HDRC)
drivers/usb/musb/musb_core.h:#ifndef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/musb_core.h:#error bogus Kconfig output ... select CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/musb_core.h:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/musb_core.h:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/musb_core.h:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/musb_core.h:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/musb_core.h:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/musb_core.h:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/tusb6010.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/tusb6010.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC
drivers/usb/musb/tusb6010.c:#ifdef CONFIG_USB_GADGET_MUSB_HDRC

NAK

-- 
balbi
