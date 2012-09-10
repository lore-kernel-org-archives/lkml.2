Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab2IJSLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:11:42 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50906 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2IJSLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:11:41 -0400
Date: Mon, 10 Sep 2012 11:08:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] USB/host: Cleanup unneccessary irq disable code
Message-ID: <20120910180857.GA12223@kroah.com>
References: <1347009599.1119.9.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347009599.1119.9.camel@cliu38-desktop-build>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 05:19:59PM +0800, Chuansheng Liu wrote:
> Because the IRQF_DISABLED as the flag is now a NOOP and has been
> deprecated and in hardirq context the interrupt is disabled.
> 
> so in usb/host code:
> Removing the usage of flag IRQF_DISABLED;
> Removing the calling local_irq save/restore actions in irq
> handler usb_hcd_irq();
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> ---
>  drivers/usb/core/hcd.c       |   15 ---------------
>  drivers/usb/host/ehci-ls1x.c |    2 +-
>  drivers/usb/host/ohci-xls.c  |    2 +-
>  3 files changed, 2 insertions(+), 17 deletions(-)

This fails to apply to my usb-next branch for some odd reason, please
refresh it and resend.

thanks,

greg k-h
