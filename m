Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1BOOpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:45:11 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22057 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab1BOOpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:45:09 -0500
Date: Tue, 15 Feb 2011 15:44:06 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Jiri Kosina <jkosina@suse.cz>
cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        dmitry pervushin <dimka@embeddedalley.com>
Subject: Re: [PATCH][trivial] Freescale STMP37XX/STMP378X Application UART
 driver: remove duplicate linux/device.h include
In-Reply-To: <alpine.LNX.2.00.1102151151560.2160@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1102151543340.27267@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102142351100.4530@swampdragon.chaosbits.net> <alpine.LNX.2.00.1102151151560.2160@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Jiri Kosina wrote:

> On Mon, 14 Feb 2011, Jesper Juhl wrote:
> 
> > Do not include linux/device.h twice in drivers/tty/serial/mxs-auart.c .
> > Once is enough.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  mxs-auart.c |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
> > index 6d01ac9..7e02c9c 100644
> > --- a/drivers/tty/serial/mxs-auart.c
> > +++ b/drivers/tty/serial/mxs-auart.c
> > @@ -15,7 +15,6 @@
> >   */
> >  
> >  #include <linux/kernel.h>
> > -#include <linux/device.h>
> >  #include <linux/errno.h>
> >  #include <linux/init.h>
> >  #include <linux/console.h>
> 
> I don't see this file in Linus' tree as of now, so I guess this is -next 
> stuff. Though I will not be applying it, and will let Sascha/Dmitry to 
> take care of it.
> 

Correct. Patch is against linux-next.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

