Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab1ILOxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:53:32 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47120 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757788Ab1ILOxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:53:31 -0400
X-Sasl-enc: nwdeTBJjX5Cp1b3pM96TOSxf2jaEkKgTyhnRwztteaAx 1315839210
Date: Mon, 12 Sep 2011 16:53:20 +0200
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, driverdevel <devel@driverdev.osuosl.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>
Subject: Re: [PATCH] staging: fix comedi build when ISA_DMA_API is enabled
 but COMEDI_PCI is not enabled
Message-ID: <20110912145320.GA28855@kroah.com>
References: <4E68E7F9.4020906@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E68E7F9.4020906@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 09:06:17AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix build when CONFIG_ISA_DMA_API is enabled but
> CONFIG_COMEDI_PCI[_DRIVERS] is not enabled.
> Fixes these build errors:
> 
> drivers/staging/comedi/drivers/ni_labpc.c: In function 'labpc_ai_cmd':
> drivers/staging/comedi/drivers/ni_labpc.c:1351: error: implicit declaration of function 'labpc_suggest_transfer_size'
> drivers/staging/comedi/drivers/ni_labpc.c: At top level:
> drivers/staging/comedi/drivers/ni_labpc.c:1802: error: conflicting types for 'labpc_suggest_transfer_size'
> drivers/staging/comedi/drivers/ni_labpc.c:1351: note: previous implicit declaration of 'labpc_suggest_transfer_size' was here
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
> 
> Greg, I had previously said that this patch was not needed since
> you had merged a larger patch, but I had another build error which
> this patch fixes, so it is now needed in mainline.

So this is needed in Linus's tree now?  Or in linux-next?  It doesn't
apply to my staging-next tree so I'm confused.

thanks,

greg k-h
