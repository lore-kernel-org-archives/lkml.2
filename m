Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab0KDN1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 09:27:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:35268 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab0KDN1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 09:27:15 -0400
Date: Thu, 4 Nov 2010 06:19:44 -0700
From: Greg KH <gregkh@suse.de>
To: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Cc: kernel@pengutronix.de, Sergei Shtylyov <sshtylyov@mvista.com>,
        matthieu.castet@parrot.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Nguyen Dinh-R00091 <R00091@freescale.com>
Subject: Re: [PATCH] USB: ehci/mxc: compile fix
Message-ID: <20101104131944.GB10390@suse.de>
References: <Pine.LNX.4.44L0.1010290956490.1588-100000@iolanthe.rowland.org> <1288690257-16801-1-git-send-email-u.kleine-koenig@pengutronix.de> <86A0E76937111F4C92FABEC0A20988510523CBC9@az33exm21> <20101104102818.GC16938@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104102818.GC16938@pengutronix.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 11:28:18AM +0100, Uwe Kleine-K?nig wrote:
> Hi Greg,
> 
> On Tue, Nov 02, 2010 at 07:05:27AM -0700, Nguyen Dinh-R00091 wrote:
> > Hi Uwe,
> > 
> > > -----Original Message-----
> > > From: Uwe Kleine-K?nig [mailto:u.kleine-koenig@pengutronix.de]
> > > Sent: Tuesday, November 02, 2010 4:31 AM
> > > To: Greg KH
> > > Cc: kernel@pengutronix.de; Sergei Shtylyov; matthieu.castet@parrot.com;
> > > linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org; Nguyen Dinh-
> > > R00091; Nguyen Dinh-R00091; Alan Stern
> > > Subject: [PATCH] USB: ehci/mxc: compile fix
> > > 
> > > Commit
> > > 	65fd427 (USB: ehci tdi : let's tdi_reset set host mode)
> > > 
> > > broke the build using ARM's mx51_defconfig:
> > > 
> > >  	  CC      drivers/usb/host/ehci-hcd.o
> > >  	In file included from drivers/usb/host/ehci-hcd.c:1166:
> > >  	drivers/usb/host/ehci-mxc.c: In function 'ehci_mxc_drv_probe':
> > >  	drivers/usb/host/ehci-mxc.c:192: error: 'ehci' undeclared (first
> > > use in this function)
> > >  	drivers/usb/host/ehci-mxc.c:192: error: (Each undeclared identifier
> > > is reported only once
> > >  	drivers/usb/host/ehci-mxc.c:192: error: for each function it
> > > appears in.)
> > >  	drivers/usb/host/ehci-mxc.c:117: warning: unused variable 'temp'
> > >  	make[3]: *** [drivers/usb/host/ehci-hcd.o] Error 1
> > >  	make[2]: *** [drivers/usb/host/ehci-hcd.o] Error 2
> > >  	make[1]: *** [sub-make] Error 2
> > >  	make: *** [all] Error 2
> > > 
> > > Fix it together with the warning about the unused variable and use
> > > msleep instead of mdelay as requested by Alan Stern.
> > > 
> > > Cc: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> > > Cc: Alan Stern <stern@rowland.harvard.edu>
> > > Signed-off-by: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
> > > ---
> > > Hello,
> > > 
> > > I currently have no hardware to test it, so I only verified it to
> > > compile.
> > > 
> > > Dinh: I changed your Tested-by to Cc for the new patch, do you care to
> > > retest?
> > 
> > Retested - check!
> Do you take this patch and "USB: Fix FSL USB driver on non Open Firmware
> systems"?

Not yet, I'm at the Plumbers conference and have had limited time to be
committing patches at the moment.  It's in my to-apply queue, so don't
worry, it's not lost.

thanks,

greg k-h
