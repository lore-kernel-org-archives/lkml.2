Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab1EPDyt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 23:54:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39592 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab1EPDyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 23:54:46 -0400
Date: Sun, 15 May 2011 15:35:50 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] gpiolib: export gpiochip_find
Message-ID: <20110515213550.GD30725@angua.secretlab.ca>
References: <20110416093015.3befd780@endymion.delvare>
 <20110513105220.4b61a5be@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513105220.4b61a5be@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 10:52:20AM +0200, Jean Delvare wrote:
> Hi Grant,
> 
> On Sat, 16 Apr 2011 09:30:15 +0200, Jean Delvare wrote:
> > Export function gpiochip_find so that modules can use it.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > ---
> > I need this to add support for SMBus multiplexing on my Asus Z8NA-D6
> > board.
> > 
> >  drivers/gpio/gpiolib.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > --- linux-2.6.39-rc3.orig/drivers/gpio/gpiolib.c	2011-03-30 10:57:19.000000000 +0200
> > +++ linux-2.6.39-rc3/drivers/gpio/gpiolib.c	2011-04-16 09:00:25.000000000 +0200
> > @@ -1165,6 +1165,7 @@ struct gpio_chip *gpiochip_find(void *da
> >  
> >  	return chip;
> >  }
> > +EXPORT_SYMBOL_GPL(gpiochip_find);
> >  
> >  /* These "optional" allocation calls help prevent drivers from stomping
> >   * on each other, and help provide better diagnostics in debugfs.
> 
> I am sorry to insist, but this patch seems quite straightforward, it
> shouldn't take long to review. Do you have any problem with it? If not,
> please apply it. I really would like to have it in kernel 2.6.40, as
> the rest of my SMBus multiplexing support effort depends on it.

Merged, thanks.

Sorry for the delay.  All the activity around UDS and getting the
ARM device tree patches into a state ready for merging pretty much
eliminated any chance I've had to look at gpio stuff over the last
month.  :-(  I'm trying to get through the backlog now.

g.

