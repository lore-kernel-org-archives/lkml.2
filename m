Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683Ab2BJSOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:14:44 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61426 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759615Ab2BJSOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:14:43 -0500
Date: Fri, 10 Feb 2012 10:11:16 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] usb: add missing Kconfig UWB select to USB_WHCI_HCD and
 USB_HWA_HCD
Message-ID: <20120210181116.GA19806@kroah.com>
References: <1328857675.7327.8.camel@marge.simpson.net>
 <4F3541AE.50807@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3541AE.50807@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 08:11:26AM -0800, Randy Dunlap wrote:
> On 02/09/2012 11:07 PM, Mike Galbraith wrote:
> > usb: add missing Kconfig UWB select to USB_WHCI_HCD and USB_HWA_HCD
> > 
> > cripts/kconfig/conf --oldconfig Kconfig
> > warning: (USB_WHCI_HCD && USB_HWA_HCD) selects USB_WUSB which has unmet direct dependencies (USB_SUPPORT && EXPERIMENTAL && USB && PCI && UWB)
> > warning: (USB_WHCI_HCD) selects UWB_WHCI which has unmet direct dependencies (UWB && PCI)
> > warning: (USB_WHCI_HCD && USB_HWA_HCD) selects USB_WUSB which has unmet direct dependencies (USB_SUPPORT && EXPERIMENTAL && USB && PCI && UWB)
> > warning: (USB_WHCI_HCD) selects UWB_WHCI which has unmet direct dependencies (UWB && PCI)
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> I have 2 patches in linux-next that fix the UWB/WUSB problems by using "depends on"
> instead...

Yes, this should all now be resolved, Mike can you verify this please?

thanks,

greg k-h
