Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110Ab2EPRUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:20:04 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54854 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2EPRUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:20:01 -0400
Date: Wed, 16 May 2012 19:19:49 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Takahiro Shimizu <tshimizu818@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp_pch: Add missing #include <linux/slab.h>
Message-ID: <20120516171949.GB3587@netboy.at.omicron.at>
References: <1337169017-15835-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337169017-15835-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 01:50:17PM +0200, Geert Uytterhoeven wrote:
> drivers/ptp/ptp_pch.c: In function 'pch_remove':
> drivers/ptp/ptp_pch.c:576:2: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]
> drivers/ptp/ptp_pch.c: In function 'pch_probe':
> drivers/ptp/ptp_pch.c:587:2: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Richard Cochran <richardcochran@gmail.com>

Thanks,
Richard

> ---
> Not even compile-tested, as it fails on parisc only.
> http://kisskb.ellerman.id.au/kisskb/buildresult/6312813/
> 
>  drivers/ptp/ptp_pch.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
> index 375eb04..6fff680 100644
> --- a/drivers/ptp/ptp_pch.c
> +++ b/drivers/ptp/ptp_pch.c
> @@ -30,6 +30,7 @@
>  #include <linux/module.h>
>  #include <linux/pci.h>
>  #include <linux/ptp_clock_kernel.h>
> +#include <linux/slab.h>
>  
>  #define STATION_ADDR_LEN	20
>  #define PCI_DEVICE_ID_PCH_1588	0x8819
> -- 
> 1.7.0.4
> 
