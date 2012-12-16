Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab2LPUkT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 15:40:19 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:37827 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2LPUkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 15:40:17 -0500
Date: Sun, 16 Dec 2012 21:40:06 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Vinod Koul <vinod.koul@linux.intel.com>, Dan Williams <djbw@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dma: ipu: Drop unused spinlock
Message-ID: <20121216214006.29f3152c@endymion.delvare>
In-Reply-To: <1347592212.1943.15.camel@vkoul-udesk3>
References: <20120906091935.64c851ac@endymion.delvare>
	<1347592212.1943.15.camel@vkoul-udesk3>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2012 08:40:12 +0530, Vinod Koul wrote:
> On Thu, 2012-09-06 at 09:19 +0200, Jean Delvare wrote:
> > I was checking why this spinlock was never initialized, but it turns
> > out it's not used anywhere, so we can drop it.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Dan Williams <djbw@fb.com>
> > ---
> > I can't even build-test this.
> > 
> >  drivers/dma/ipu/ipu_irq.c |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > --- linux-3.6-rc4.orig/drivers/dma/ipu/ipu_irq.c	2012-08-04 21:49:26.000000000 +0200
> > +++ linux-3.6-rc4/drivers/dma/ipu/ipu_irq.c	2012-09-06 09:13:31.034228670 +0200
> > @@ -45,7 +45,6 @@ static void ipu_write_reg(struct ipu *ip
> >  struct ipu_irq_bank {
> >  	unsigned int	control;
> >  	unsigned int	status;
> > -	spinlock_t	lock;
> >  	struct ipu	*ipu;
> >  };
>
> Dan, you okay with this?

What happened to this patch? Dan, please?

-- 
Jean Delvare
