Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab0IHHJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 03:09:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:51175 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350Ab0IHHJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 03:09:15 -0400
Date: Wed, 8 Sep 2010 00:08:32 -0700
From: Greg KH <gregkh@suse.de>
To: Vipin Mehta <Vipin.Mehta@Atheros.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH 2/2] staging: ath6kl: use native methods from kernel
	library
Message-ID: <20100908070832.GA24777@suse.de>
References: <09b7da2e5462e0b855617ff5308ed6efb4fc9cab.1283872748.git.andy.shevchenko@gmail.com> <8b251244717765e795b92a1f7335f8af98e5706f.1283872748.git.andy.shevchenko@gmail.com> <35B17FE5076C7040809188FBE7913F983F23479F74@SC1EXMB-MBCL.global.atheros.com> <20100908000331.GA15785@suse.de> <35B17FE5076C7040809188FBE7913F983F2381D71F@SC1EXMB-MBCL.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35B17FE5076C7040809188FBE7913F983F2381D71F@SC1EXMB-MBCL.global.atheros.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 07:29:30PM -0700, Vipin Mehta wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@suse.de]
> > Sent: Tuesday, September 07, 2010 5:04 PM
> > To: Vipin Mehta
> > Cc: Andy Shevchenko; linux-kernel@vger.kernel.org;
> > devel@driverdev.osuosl.org
> > Subject: Re: [PATCH 2/2] staging: ath6kl: use native methods from kernel
> > library
> > 
> > On Tue, Sep 07, 2010 at 02:18:02PM -0700, Vipin Mehta wrote:
> > > Andy,
> > > Thanks for the patch. Although the driver supports Linux but it has
> > > been architected to support other OSes if desired. The code is,
> > > therefore, organized into generic and OS specific components with the
> > > latter part of the code captured into the os/linux directory. As such,
> > > the patch will be more useful if we can move out the inclusion of
> > > linux specific header files <linux/kernel.h> and <linux/ctype.h> into
> > > a header file in os/linux/include directory.
> > 
> > Ick, no.
> > 
> > The driver is now in the main kernel tree, the "compatiblity" wrappers
> > are to now be removed as the kernel code does not need to run on any
> > other operating systems.
> > 
> > That whole subdir needs to be deleted entirely.
> > 
> > > You can refer to
> > > os/linux/include/osapi_linux.h for example. A macro could be defined
> > > which would use linux specific APIs for Linux and keep the original
> > > definitions for any other OS.
> > 
> > Again, no, this is not ok at all.  If you are going to insist on trying
> > to do this for the driver, I will just delete it from the tree right now
> > as that is now how kernel development happens, sorry.
> 
> Got it. I think we can discard my suggestion in that case. The patch
> looks good otherwise. It is ok from my side and could be pushed in to
> the driver.

Thanks, will do.

greg k-h
