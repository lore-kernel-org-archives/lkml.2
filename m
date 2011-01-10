Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1AJViH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:38:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701Ab1AJViF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:38:05 -0500
Date: Mon, 10 Jan 2011 22:37:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@gmail.com>, Chris Ball <cjb@laptop.org>,
        David Vrabel <david.vrabel@csr.com>
Subject: Re: [PATCH] USB SD Host Controller: Including usb.h once is enough
In-Reply-To: <alpine.LNX.2.00.1101102153280.32164@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1101102236080.26685@pobox.suse.cz>
References: <alpine.LNX.2.00.1101102153280.32164@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011, Jesper Juhl wrote:

> 
> Including usb.h once is enough in drivers/mmc/host/ushc.c
> This removes the duplicate.
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  ushc.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/ushc.c b/drivers/mmc/host/ushc.c
> index f8f65df..f08f944 100644
> --- a/drivers/mmc/host/ushc.c
> +++ b/drivers/mmc/host/ushc.c
> @@ -19,7 +19,6 @@
>  #include <linux/module.h>
>  #include <linux/usb.h>
>  #include <linux/kernel.h>
> -#include <linux/usb.h>
>  #include <linux/slab.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/mmc/host.h>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
