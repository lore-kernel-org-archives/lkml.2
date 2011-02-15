Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab1BORgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:36:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33785 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab1BORgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:36:06 -0500
Date: Tue, 15 Feb 2011 18:36:04 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, dmitry pervushin <dimka@embeddedalley.com>,
        trivial@kernel.org
Subject: Re: [PATCH][trivial] Freescale STMP37XX/STMP378X Application UART
 driver: remove duplicate linux/device.h include
Message-ID: <20110215173604.GB26437@pengutronix.de>
References: <alpine.LNX.2.00.1102142351100.4530@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1102142351100.4530@swampdragon.chaosbits.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:35:45 up 31 days,  3:42, 87 users,  load average: 0.97, 0.39,
 0.19
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 11:54:00PM +0100, Jesper Juhl wrote:
> Do not include linux/device.h twice in drivers/tty/serial/mxs-auart.c .
> Once is enough.

Applied. Should show up in -next tomorrow.

Sascha

> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  mxs-auart.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
> index 6d01ac9..7e02c9c 100644
> --- a/drivers/tty/serial/mxs-auart.c
> +++ b/drivers/tty/serial/mxs-auart.c
> @@ -15,7 +15,6 @@
>   */
>  
>  #include <linux/kernel.h>
> -#include <linux/device.h>
>  #include <linux/errno.h>
>  #include <linux/init.h>
>  #include <linux/console.h>
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Plain text mails only, please.
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
