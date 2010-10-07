Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0JGPl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 11:41:26 -0400
Received: from kroah.org ([198.145.64.141]:40097 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab0JGPkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 11:40:47 -0400
Date: Thu, 7 Oct 2010 08:36:38 -0700
From: Greg KH <greg@kroah.com>
To: tlinder <tlinder@codeaurora.org>
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Robert Lukassen <robert.lukassen@tomtom.com>,
        Fabien Chouteau <fabien.chouteau@barco.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH v2 3/3] usb:gadget: Add SuperSpeed support to the
 Gadget Framework
Message-ID: <20101007153638.GB26129@kroah.com>
References: <1286465101-12539-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286465101-12539-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 05:24:57PM +0200, tlinder wrote:
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -520,11 +520,11 @@ config USB_GADGET_DUMMY_HCD
>  	  side is the master; the gadget side is the slave.  Gadget drivers
>  	  can be high, full, or low speed; and they have access to endpoints
>  	  like those from NET2280, PXA2xx, or SA1100 hardware.
> -	  
> +
>  	  This may help in some stages of creating a driver to embed in a
>  	  Linux device, since it lets you debug several parts of the gadget
>  	  driver without its hardware or drivers being involved.
> -	  
> +
>  	  Since such a gadget side driver needs to interoperate with a host
>  	  side Linux-USB device driver, this may help to debug both sides
>  	  of a USB protocol stack.

While deleting trailing whitespace is a nice thing to do, it has nothing
to do with your patch, so please don't add it to there, it only detracts
from what you are trying to do.

> @@ -633,7 +645,7 @@ config USB_ETH
>  	help
>  	  This driver implements Ethernet style communication, in one of
>  	  several ways:
> -	  
> +
>  	   - The "Communication Device Class" (CDC) Ethernet Control Model.
>  	     That protocol is often avoided with pure Ethernet adapters, in
>  	     favor of simpler vendor-specific hardware, but is widely
> @@ -673,7 +685,7 @@ config USB_ETH_RNDIS
>  	   If you say "y" here, the Ethernet gadget driver will try to provide
>  	   a second device configuration, supporting RNDIS to talk to such
>  	   Microsoft USB hosts.
> -	   
> +
>  	   To make MS-Windows work with this, use Documentation/usb/linux.inf
>  	   as the "driver info file".  For versions of MS-Windows older than
>  	   XP, you'll need to download drivers from Microsoft's website; a URL

Same here.

thanks,

greg k-h
