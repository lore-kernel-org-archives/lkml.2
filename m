Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab1CSAvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 20:51:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932813Ab1CSAve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 20:51:34 -0400
Date: Fri, 18 Mar 2011 17:23:35 -0700
From: Greg KH <gregkh@suse.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Daniel Trautmann <dtrautmann@ibhsoftec-sps.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Manuel Traut <manut@linutronix.de>
Subject: Re: [PATCH] uio_netx: Add support for netPLC cards
Message-ID: <20110319002335.GC14249@suse.de>
References: <F988B291A6BAC142A66450B2FED7EF55852377B3@ENTWMAIL.ENTWDOM.local>
 <20110319001210.GC2761@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110319001210.GC2761@local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 19, 2011 at 01:12:11AM +0100, Hans J. Koch wrote:
> On Thu, Mar 17, 2011 at 11:40:59AM +0000, Daniel Trautmann wrote:
> > This patch adds support for Hilscher / IBHsoftec netPLC cards to uio_netx userspace IO driver.
> > 
> > Signed-off-by: Daniel Trautmann <dtrautmann@ibhsoftec-sps.de>
> > ---
> >  drivers/uio/uio_netx.c |   19 +++++++++++++++++++
> >  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> Against what kernel is that supposed to apply? It doesn't apply against
> Linus' current tree here.
> 
> And, please, run your patch through scripts/checkpatch.pl before posting it.
> 
> I get:
> -----------------------
> total: 15 errors, 16 warnings, 37 lines checked
> 
> NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
>       scripts/cleanfile
> -----------------------
> I find 15 errors in 19 insertions a bit too much. Most of it is whitespace,
> so it might be a problem with your mail client. Please check.
> 
> > 
> > diff --git a/drivers/uio/uio_netx.c b/drivers/uio/uio_netx.c
> > index 5ffdb48..7921190 100644
> > --- a/drivers/uio/uio_netx.c
> > +++ b/drivers/uio/uio_netx.c
> > @@ -18,6 +18,9 @@
> >  
> >  #define PCI_VENDOR_ID_HILSCHER         0x15CF
> >  #define PCI_DEVICE_ID_HILSCHER_NETX    0x0000
> > +#define PCI_DEVICE_ID_HILSCHER_NETPLC  0x0010
> 
> Hmpf, yes... The three defines above should go to include/linux/pci_ids.h

No, read the top of that file please.  They belong here.

> I should have done that from the beginning, could you fix it now?

Please don't.

thanks,

greg k-h
