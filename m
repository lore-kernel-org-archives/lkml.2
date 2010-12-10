Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0LJXS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 18:18:27 -0500
Received: from kroah.org ([198.145.64.141]:57710 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab0LJXS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 18:18:26 -0500
Date: Fri, 10 Dec 2010 15:16:08 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: gregkh@suse.de, Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 6 (pch_uart)
Message-ID: <20101210231608.GA12155@kroah.com>
References: <20101206140055.34289498.sfr@canb.auug.org.au>
 <AANLkTi=iCZ=XQk3zXwK-BPnK4=9SU5W-arf+rom9dx8V@mail.gmail.com>
 <20101206081422.0608c50d.randy.dunlap@oracle.com>
 <20101210092010.dbff7834.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210092010.dbff7834.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 09:20:10AM -0800, Randy Dunlap wrote:
> On Mon, 6 Dec 2010 08:14:22 -0800 Randy Dunlap wrote:
> 
> > On Mon, 6 Dec 2010 16:09:33 +0100 Zimny Lech wrote:
> > 
> > > Ave,
> > > 
> > > 2010/12/6 Stephen Rothwell <sfr@canb.auug.org.au>:
> > > > Hi all,
> > > >
> > > > [The mirroring on kernel.org is currently being slow, so this release may
> > > > not be available yet.]
> > > >
> > > > Changes since 20101203:
> > > >
> > > 
> > > Nothing new here, only known issues
> > > 
> > > Kernel: arch/x86/boot/bzImage is ready  (#5)
> > >   Building modules, stage 2.
> > >   MODPOST 314 modules
> > > ERROR: "dma_release_channel" [drivers/serial/pch_uart.ko] undefined!
> > > ERROR: "__dma_request_channel" [drivers/serial/pch_uart.ko] undefined!
> > > WARNING: modpost: Found 4 section mismatch(es).
> > > To see full details build your kernel with:
> > > 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> > > make[2]: *** [__modpost] Error 1
> > > make[1]: *** [modules] Error 2
> > > make: *** [sub-make] Error 2
> > 
> > Greg, are you going to merge the patch that I posted for this one?
> > 
> 
> ping.  Still happening in linux-next 20101210.

Now applied.
