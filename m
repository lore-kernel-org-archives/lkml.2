Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab1BOKwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 05:52:31 -0500
Received: from cantor.suse.de ([195.135.220.2]:60427 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab1BOKw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 05:52:29 -0500
Date: Tue, 15 Feb 2011 11:52:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        dmitry pervushin <dimka@embeddedalley.com>
Subject: Re: [PATCH][trivial] Freescale STMP37XX/STMP378X Application UART
 driver: remove duplicate linux/device.h include
In-Reply-To: <alpine.LNX.2.00.1102142351100.4530@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1102151151560.2160@pobox.suse.cz>
References: <alpine.LNX.2.00.1102142351100.4530@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011, Jesper Juhl wrote:

> Do not include linux/device.h twice in drivers/tty/serial/mxs-auart.c .
> Once is enough.
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

I don't see this file in Linus' tree as of now, so I guess this is -next 
stuff. Though I will not be applying it, and will let Sascha/Dmitry to 
take care of it.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
