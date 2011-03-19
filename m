Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800Ab1CSCCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 22:02:40 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:38720 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756570Ab1CSCCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 22:02:33 -0400
Date: Sat, 19 Mar 2011 03:02:33 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Greg KH <gregkh@suse.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Daniel Trautmann <dtrautmann@ibhsoftec-sps.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Manuel Traut <manut@linutronix.de>
Subject: Re: [PATCH] uio_netx: Add support for netPLC cards
Message-ID: <20110319020233.GD2761@local>
References: <F988B291A6BAC142A66450B2FED7EF55852377B3@ENTWMAIL.ENTWDOM.local>
 <20110319001210.GC2761@local>
 <20110319002335.GC14249@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110319002335.GC14249@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 05:23:35PM -0700, Greg KH wrote:
> On Sat, Mar 19, 2011 at 01:12:11AM +0100, Hans J. Koch wrote:
> > On Thu, Mar 17, 2011 at 11:40:59AM +0000, Daniel Trautmann wrote:
> > > This patch adds support for Hilscher / IBHsoftec netPLC cards to uio_netx userspace IO driver.
> > > 
> > > Signed-off-by: Daniel Trautmann <dtrautmann@ibhsoftec-sps.de>
> > > ---
> > >  drivers/uio/uio_netx.c |   19 +++++++++++++++++++
> > >  1 files changed, 19 insertions(+), 0 deletions(-)
> > 
> > Against what kernel is that supposed to apply? It doesn't apply against
> > Linus' current tree here.
> > 
> > And, please, run your patch through scripts/checkpatch.pl before posting it.
> > 
> > I get:
> > -----------------------
> > total: 15 errors, 16 warnings, 37 lines checked
> > 
> > NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
> >       scripts/cleanfile
> > -----------------------
> > I find 15 errors in 19 insertions a bit too much. Most of it is whitespace,
> > so it might be a problem with your mail client. Please check.
> > 
> > > 
> > > diff --git a/drivers/uio/uio_netx.c b/drivers/uio/uio_netx.c
> > > index 5ffdb48..7921190 100644
> > > --- a/drivers/uio/uio_netx.c
> > > +++ b/drivers/uio/uio_netx.c
> > > @@ -18,6 +18,9 @@
> > >  
> > >  #define PCI_VENDOR_ID_HILSCHER         0x15CF
> > >  #define PCI_DEVICE_ID_HILSCHER_NETX    0x0000
> > > +#define PCI_DEVICE_ID_HILSCHER_NETPLC  0x0010
> > 
> > Hmpf, yes... The three defines above should go to include/linux/pci_ids.h
> 
> No, read the top of that file please.  They belong here.

Ooops, yes.

> 
> > I should have done that from the beginning, could you fix it now?
> 
> Please don't.

Now I remember why I once put them here :)

Thanks,
Hans

