Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1AXVEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:04:24 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15636 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab1AXVEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:04:23 -0500
Date: Mon, 24 Jan 2011 22:05:05 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Chris Ball <cjb@laptop.org>
cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@csr.com>, Axel Lin <axel.lin@gmail.com>,
        trivial@kernel.org
Subject: Re: [PATCH] MMC, USHC: Don't double include usb.h in ushc.c
In-Reply-To: <20110124210202.GA11110@void.printf.net>
Message-ID: <alpine.LNX.2.00.1101242204020.10252@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101242156050.10252@swampdragon.chaosbits.net> <20110124210202.GA11110@void.printf.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011, Chris Ball wrote:

> Jesper,
> 
> On Mon, Jan 24, 2011 at 09:59:25PM +0100, Jesper Juhl wrote:
> > We include linux/usb.h twice in drivers/mmc/host/ushc.c - once is enough.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  ushc.c |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/mmc/host/ushc.c b/drivers/mmc/host/ushc.c
> > index f8f65df..f08f944 100644
> > --- a/drivers/mmc/host/ushc.c
> > +++ b/drivers/mmc/host/ushc.c
> > @@ -19,7 +19,6 @@
> >  #include <linux/module.h>
> >  #include <linux/usb.h>
> >  #include <linux/kernel.h>
> > -#include <linux/usb.h>
> >  #include <linux/slab.h>
> >  #include <linux/dma-mapping.h>
> >  #include <linux/mmc/host.h>
> > 
> 
> I've already replied to you ACKing this patch, and pushed it to mmc-next. 
> 
Odd, I don't see that in my mailbox :-( But then I've had a few incidents 
of being bling in that regard lately, so it's probably my fault. Sorry.


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

