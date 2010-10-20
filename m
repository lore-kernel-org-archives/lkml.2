Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0JTSZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:25:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34230 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab0JTSZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:25:39 -0400
Date: Wed, 20 Oct 2010 21:25:16 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        "Balbi, Felipe" <balbi@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 2/3] usb: trivial Kconfig cleanups
Message-ID: <20101020182516.GD3958@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
 <1287482608-11320-3-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1287482608-11320-3-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 05:03:27AM -0500, Felipe Contreras wrote:
>Note: USB_GADGET_MUSB_HDRC is already defined in usb/gadget.
>
>Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>---
> drivers/usb/core/Kconfig   |    3 ---
> drivers/usb/gadget/Kconfig |    2 +-
> drivers/usb/musb/Kconfig   |   17 ++++-------------

for drivers/usb/musb/Kconfig:

Acked-by: Felipe Balbi <balbi@ti.com>

-- 
balbi
