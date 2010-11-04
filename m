Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab0KDK23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 06:28:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39204 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab0KDK2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 06:28:25 -0400
Date: Thu, 4 Nov 2010 11:28:18 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: kernel@pengutronix.de, Sergei Shtylyov <sshtylyov@mvista.com>,
        matthieu.castet@parrot.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Nguyen Dinh-R00091 <R00091@freescale.com>
Subject: Re: [PATCH] USB: ehci/mxc: compile fix
Message-ID: <20101104102818.GC16938@pengutronix.de>
References: <Pine.LNX.4.44L0.1010290956490.1588-100000@iolanthe.rowland.org> <1288690257-16801-1-git-send-email-u.kleine-koenig@pengutronix.de> <86A0E76937111F4C92FABEC0A20988510523CBC9@az33exm21>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86A0E76937111F4C92FABEC0A20988510523CBC9@az33exm21>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tue, Nov 02, 2010 at 07:05:27AM -0700, Nguyen Dinh-R00091 wrote:
> Hi Uwe,
> 
> > -----Original Message-----
> > From: Uwe Kleine-König [mailto:u.kleine-koenig@pengutronix.de]
> > Sent: Tuesday, November 02, 2010 4:31 AM
> > To: Greg KH
> > Cc: kernel@pengutronix.de; Sergei Shtylyov; matthieu.castet@parrot.com;
> > linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org; Nguyen Dinh-
> > R00091; Nguyen Dinh-R00091; Alan Stern
> > Subject: [PATCH] USB: ehci/mxc: compile fix
> > 
> > Commit
> > 	65fd427 (USB: ehci tdi : let's tdi_reset set host mode)
> > 
> > broke the build using ARM's mx51_defconfig:
> > 
> >  	  CC      drivers/usb/host/ehci-hcd.o
> >  	In file included from drivers/usb/host/ehci-hcd.c:1166:
> >  	drivers/usb/host/ehci-mxc.c: In function 'ehci_mxc_drv_probe':
> >  	drivers/usb/host/ehci-mxc.c:192: error: 'ehci' undeclared (first
> > use in this function)
> >  	drivers/usb/host/ehci-mxc.c:192: error: (Each undeclared identifier
> > is reported only once
> >  	drivers/usb/host/ehci-mxc.c:192: error: for each function it
> > appears in.)
> >  	drivers/usb/host/ehci-mxc.c:117: warning: unused variable 'temp'
> >  	make[3]: *** [drivers/usb/host/ehci-hcd.o] Error 1
> >  	make[2]: *** [drivers/usb/host/ehci-hcd.o] Error 2
> >  	make[1]: *** [sub-make] Error 2
> >  	make: *** [all] Error 2
> > 
> > Fix it together with the warning about the unused variable and use
> > msleep instead of mdelay as requested by Alan Stern.
> > 
> > Cc: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> > Hello,
> > 
> > I currently have no hardware to test it, so I only verified it to
> > compile.
> > 
> > Dinh: I changed your Tested-by to Cc for the new patch, do you care to
> > retest?
> 
> Retested - check!
Do you take this patch and "USB: Fix FSL USB driver on non Open Firmware
systems"?

Just drop me a note if you need them resent.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
