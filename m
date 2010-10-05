Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab0JEXXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 19:23:08 -0400
Received: from kroah.org ([198.145.64.141]:46878 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab0JEXXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 19:23:06 -0400
Date: Tue, 5 Oct 2010 16:22:58 -0700
From: Greg KH <greg@kroah.com>
To: pavan_savoy@ti.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 0/4] move TI_ST driver out of staging
Message-ID: <20101005232258.GA17277@kroah.com>
References: <1286323717-2925-1-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286323717-2925-1-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 08:08:33PM -0400, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> Texas Instrument's WiLink 7 chipset packs wireless technologies like
> Bluetooth, FM, GPS and WLAN into a single die.
> Among these the Bluetooth, FM Rx/Tx and GPS are interfaced to a apps processor
> over a single UART.
> 
> This line discipline driver allows various protocol drivers such as Bluetooth
> BlueZ driver, FM V4L2 driver and GPS simple character device driver
> to communicate with its relevant core in the chip.
> 
> The following patches,
> 1. removes the driver from staging
> 2. adds the driver to drivers/misc/ directory since it really doesn't
> belong anywhere else
> 3. adds in the Kconfig and Makefile for the driver
> 4. modifies the drivers/misc/Kconfig and drivers/misc/Makefile for the
> driver to be available to be built along with rest of the kernel.
> 
> Pavan Savoy (4):
>   drivers:staging:ti-st: remove TI_ST from staging
>   drivers:misc: ti-st: sources for TI_ST driver

These two should be together, so we see an obvious "move the files" type
patch, not a "delete and then add" set of stuff.

>   drivers:misc: ti-st: Kconfig & Makefile for TI_ST
>   drivers:misc: modify Kconfig & Makefile for TI_ST

So this really could just be one patch all at once, care to redo?

thanks,

greg k-h
