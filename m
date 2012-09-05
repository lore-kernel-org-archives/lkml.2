Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375Ab2IEU34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 16:29:56 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57555 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753566Ab2IEU3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 16:29:53 -0400
X-Sasl-enc: Zx0awe2LtNhun+nEIMHgCN0Uf8BSFq+logcq7Iiwp55w 1346876992
Date: Wed, 5 Sep 2012 13:27:21 -0700
From: Greg KH <greg@kroah.com>
To: Felipe Balbi <balbi@ti.com>
Cc: alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: Re: [PATCH v3 03/23] serial: omap: don't access the platform_device
Message-ID: <20120905202721.GA2430@kroah.com>
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
 <1345717983-18179-4-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345717983-18179-4-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 01:32:43PM +0300, Felipe Balbi wrote:
> The driver doesn't need to know about its platform_device.
> 
> Everything the driver needs can be done through the
> struct device pointer. In case we need to use the
> OMAP-specific PM function pointers, those can make
> sure to find the device's platform_device pointer
> so they can find the struct omap_device through
> pdev->archdata field.
> 
> Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

This series fails when applying to my tty-next branch at this patch :(

Care to refresh it, and resend it, with Tony's acks added, so I can
apply it?  Note, I've already applied the first two.

thanks,

greg k-h
