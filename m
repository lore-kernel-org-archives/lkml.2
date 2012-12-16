Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab2LPVOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 16:14:23 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34452 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2LPVOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 16:14:22 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] spi: devicetree: add support for loopback mode
To: Felipe Balbi <balbi@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, spi-devel-general@lists.sourceforge.net,
        rob@landley.net, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
In-Reply-To: <20121215145546.GA15606@arwen.pp.htv.fi>
References: <1355301960-21523-1-git-send-email-balbi@ti.com> <1355301960-21523-2-git-send-email-balbi@ti.com> <20121215003224.CBFD93E0BEC@localhost> <20121215145546.GA15606@arwen.pp.htv.fi>
Date: Sun, 16 Dec 2012 21:14:14 +0000
Message-Id: <20121216211415.0DE793E0BDD@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Dec 2012 16:55:46 +0200, Felipe Balbi <balbi@ti.com> wrote:
> On Sat, Dec 15, 2012 at 12:32:24AM +0000, Grant Likely wrote:
> > On Wed, 12 Dec 2012 10:46:00 +0200, Felipe Balbi <balbi@ti.com> wrote:
> > > there are a few spi master drivers which make
> > > use of that flag but there is no way to pass it
> > > through devicetree.
> > > 
> > > This patch just creates a way to pass SPI_LOOP
> > > via devicetree.
> > 
> > I don't understand how this would be useful since loopback mode is
> > really just a test feature. Is there any reason to do loopback for
> > something other than test?
> > 
> > I think it would be better to add a sysfs or debugfs property to
> > manipulate the SPI_LOOP flag from userspace. What do you think?
> 
> might be nicer in the long run, indeed. Want me to look into it, or do
> you wanna do it yourself ?

Yes, please look into it. After all, you're the one who needs the feature/  :-)

g.

