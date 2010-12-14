Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412Ab0LNRT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:19:56 -0500
Received: from kroah.org ([198.145.64.141]:57919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757961Ab0LNRTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:19:54 -0500
Date: Tue, 14 Dec 2010 09:06:56 -0800
From: Greg KH <greg@kroah.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 0/4] Introduce hardware spinlock framework
Message-ID: <20101214170656.GA3832@kroah.com>
References: <1291420247-18171-1-git-send-email-ohad@wizery.com>
 <AANLkTin1fd=Kei7Fo6G+uR+270HdTkc71fvsA6qjBjcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin1fd=Kei7Fo6G+uR+270HdTkc71fvsA6qjBjcA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 04:31:36PM +0200, Ohad Ben-Cohen wrote:
> Hi Greg, Tony,
> 
> On Sat, Dec 4, 2010 at 1:50 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> > OMAP4 introduces a Hardware Spinlock device, which provides hardware
> > assistance for synchronization and mutual exclusion between heterogeneous
> > processors and those not operating under a single, shared operating system
> > (e.g. OMAP4 has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP).
> >
> > The intention of this hardware device is to allow remote processors,
> > that have no alternative mechanism to accomplish synchronization and mutual
> > exclusion operations, to share resources (such as memory and/or any other
> > hardware resource).
> >
> > This patchset adds hwspinlock framework that makes it possible
> > for drivers to use those hwspinlock devices and stay platform-independent.
> 
> ...
> 
> >  Documentation/hwspinlock.txt               |  299 +++++++++++++++
> >  arch/arm/mach-omap2/Makefile               |    1 +
> >  arch/arm/mach-omap2/hwspinlock.c           |   63 ++++
> >  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   64 ++++
> >  drivers/Kconfig                            |    2 +
> >  drivers/Makefile                           |    1 +
> >  drivers/hwspinlock/Kconfig                 |   22 ++
> >  drivers/hwspinlock/Makefile                |    6 +
> >  drivers/hwspinlock/hwspinlock.h            |   61 +++
> >  drivers/hwspinlock/hwspinlock_core.c       |  557 ++++++++++++++++++++++++++++
> >  drivers/hwspinlock/omap_hwspinlock.c       |  231 ++++++++++++
> >  include/linux/hwspinlock.h                 |  298 +++++++++++++++
> >  12 files changed, 1605 insertions(+), 0 deletions(-)
> 
> Can you please have a look and say if this looks OK ?

Look at what, I don't see a patch here.

I've seen a lot of discussion about this, are all of the review comments
now addressed?  Like the most important one, why is this generic code if
it's only for one specific platform?

thanks,

greg k-h
