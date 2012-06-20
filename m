Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516Ab2FTXXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:23:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab2FTXXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:23:35 -0400
Date: Wed, 20 Jun 2012 16:23:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: skel: use module_comedi_{pci_,}driver()
Message-ID: <20120620232331.GA25587@kroah.com>
References: <201206201556.51336.hartleys@visionengravers.com>
 <20120620231230.GA28411@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698E77071@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698E77071@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 06:16:52PM -0500, H Hartley Sweeten wrote:
> On Wednesday, June 20, 2012 4:13 PM, Greg KH wrote:
> > On Wed, Jun 20, 2012 at 03:56:50PM -0700, H Hartley Sweeten wrote:
> >> If PCI boards are supported, use the module_comedi_pci_driver() macro
> >> to register the module as a comedi driver and a PCI driver. Otherwise,
> >> only ISA boards are supported to use the module_comedi_driver() macro
> >> to register the module as a comedi driver.
> >> 
> >> Refactor the code a bit due to the use of the module_comedi_* macros.
> >> 
> >> Rename the comedi_driver and pci_driver variables as well as the pci
> >> driver related functions for aesthetic reasons. This makes the skel
> >> driver conform to the changes to the other comedi drivers.
> >> 
> >> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> >> Cc: Ian Abbott <abbotti@mev.co.uk>
> >> Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
> >
> > This patch fails to apply:
> >
> > patching file drivers/staging/comedi/drivers/skel.c
> > Hunk #4 FAILED at 543.
> > 1 out of 4 hunks FAILED -- saving rejects to file drivers/staging/comedi/drivers/skel.c.rej
> >
> > Care to rediff it and resend?
> 
> Hmm. It was based on next-20120620 and created with git format-patch.
> 
> Do you have any other patches to that file in your staging tree that
> have not reached the next tree yet?

Possibly, depending on when -next was created, I did just apply a bunch
of other patches a few hours ago.

> Regardless, I have some other cleanup patches for that file. I'll
> put them together as a series and repost it later.

That would be great, thanks.

greg k-h
