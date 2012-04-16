Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134Ab2DPP6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:58:45 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:48520 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab2DPP6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:58:43 -0400
Date: Mon, 16 Apr 2012 08:58:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Roland Stigge <stigge@antcom.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] USB: Add driver for NXP ISP1301 USB transceiver
Message-ID: <20120416155839.GA23627@kroah.com>
References: <Pine.LNX.4.44L0.1204161106410.1408-100000@iolanthe.rowland.org>
 <4F8C4028.5090602@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8C4028.5090602@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 05:52:08PM +0200, Roland Stigge wrote:
> On 04/16/2012 05:09 PM, Alan Stern wrote:
> >>  drivers/usb/Makefile        |    5 ++
> >>  drivers/usb/misc/Kconfig    |   12 ++++++
> >>  drivers/usb/misc/Makefile   |    1 
> >>  drivers/usb/misc/isp1301.c  |   64 ++++++++++++++++++++++++++++++++++
> >>  include/linux/usb/isp1301.h |   82 ++++++++++++++++++++++++++++++++++++++++++++
> > 
> > You know, drivers/usb/misc is meant for miscellaneous USB device 
> > drivers.  Not for host or transceiver drivers.
> > 
> > You should put the new file somewhere else.  Maybe in the otg 
> > directory, although that may not be completely appropriate either.  
> > Maybe something under the host directory.
> 
> The driver is used by drivers in the following directories:
> 
> drivers/usb/host/    (ohci-nxp.c)
> drivers/usb/otg/     (isp1301_omap.c)
> drivers/usb/gadget/  (lpc32xx_udc.c)
> 
> So host/ and otg/ don't look much better.
> 
> Maybe one of (new):
> 
>     drivers/usb/transceiver/
>     drivers/usb/phy/
>     drivers/usb/lowlevel/

Sure, any of those would be fine with me, but not misc please.

thanks,

greg k-h
