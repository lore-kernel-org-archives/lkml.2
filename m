Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949Ab0JSK2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:28:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46673 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933798Ab0JSK23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:28:29 -0400
Date: Tue, 19 Oct 2010 13:28:09 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        "Balbi, Felipe" <balbi@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 1/3] usb: fix Kconfig warning
Message-ID: <20101019102808.GH31170@legolas.emea.dhcp.ti.com>
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
>Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

Since this is related to MUSB, Greg to do you want me to queue for -rc0
cycle and re-send for you ?

-- 
balbi
