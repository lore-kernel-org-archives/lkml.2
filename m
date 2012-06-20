Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509Ab2FTXMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:12:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37403 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494Ab2FTXMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:12:34 -0400
Date: Wed, 20 Jun 2012 16:12:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, abbotti@mev.co.uk
Subject: Re: [PATCH] staging: comedi: skel: use module_comedi_{pci_,}driver()
Message-ID: <20120620231230.GA28411@kroah.com>
References: <201206201556.51336.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206201556.51336.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 03:56:50PM -0700, H Hartley Sweeten wrote:
> If PCI boards are supported, use the module_comedi_pci_driver() macro
> to register the module as a comedi driver and a PCI driver. Otherwise,
> only ISA boards are supported to use the module_comedi_driver() macro
> to register the module as a comedi driver.
> 
> Refactor the code a bit due to the use of the module_comedi_* macros.
> 
> Rename the comedi_driver and pci_driver variables as well as the pci
> driver related functions for aesthetic reasons. This makes the skel
> driver conform to the changes to the other comedi drivers.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Frank Mori Hess <fmhess@users.sourceforge.net>

This patch fails to apply:

patching file drivers/staging/comedi/drivers/skel.c
Hunk #4 FAILED at 543.
1 out of 4 hunks FAILED -- saving rejects to file drivers/staging/comedi/drivers/skel.c.rej

Care to rediff it and resend?

thanks,

greg k-h
