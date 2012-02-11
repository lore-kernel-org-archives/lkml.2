Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab2BKFn3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 00:43:29 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:51341 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751171Ab2BKFn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 00:43:28 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1828x4nda42T5NFFtCtf5IpxB4S2idRwF2uomw76x
	WPRP1wQNAkVCCG
Message-ID: <1328939004.7340.21.camel@marge.simpson.net>
Subject: Re: [patch] usb: add missing Kconfig UWB select to USB_WHCI_HCD and
 USB_HWA_HCD
From: Mike Galbraith <efault@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, LKML <linux-kernel@vger.kernel.org>
Date: Sat, 11 Feb 2012 06:43:24 +0100
In-Reply-To: <20120210181116.GA19806@kroah.com>
References: <1328857675.7327.8.camel@marge.simpson.net>
	 <4F3541AE.50807@xenotime.net> <20120210181116.GA19806@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 10:11 -0800, Greg Kroah-Hartman wrote: 
> On Fri, Feb 10, 2012 at 08:11:26AM -0800, Randy Dunlap wrote:
> > On 02/09/2012 11:07 PM, Mike Galbraith wrote:
> > > usb: add missing Kconfig UWB select to USB_WHCI_HCD and USB_HWA_HCD
> > > 
> > > cripts/kconfig/conf --oldconfig Kconfig
> > > warning: (USB_WHCI_HCD && USB_HWA_HCD) selects USB_WUSB which has unmet direct dependencies (USB_SUPPORT && EXPERIMENTAL && USB && PCI && UWB)
> > > warning: (USB_WHCI_HCD) selects UWB_WHCI which has unmet direct dependencies (UWB && PCI)
> > > warning: (USB_WHCI_HCD && USB_HWA_HCD) selects USB_WUSB which has unmet direct dependencies (USB_SUPPORT && EXPERIMENTAL && USB && PCI && UWB)
> > > warning: (USB_WHCI_HCD) selects UWB_WHCI which has unmet direct dependencies (UWB && PCI)
> > > 
> > > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > 
> > I have 2 patches in linux-next that fix the UWB/WUSB problems by using "depends on"
> > instead...
> 
> Yes, this should all now be resolved, Mike can you verify this please?

Nah, Randy surely did, and it would be hard to mess it up ;-)

-Mike

