Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab0DPMEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 08:04:37 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:60921 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab0DPMEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 08:04:36 -0400
Date: Fri, 16 Apr 2010 14:04:32 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Jakob Viketoft <jakob.viketoft@bitsim.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH] colibri.h: Add #include
Message-ID: <20100416120432.GQ30801@buzzloop.caiaq.de>
References: <4BC8510B.3060202@bitsim.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC8510B.3060202@bitsim.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 01:59:07PM +0200, Jakob Viketoft wrote:
> 
> CC: stable@kernel.org
> CC: Daniel Mack <daniel@caiaq.de>
> CC: Eric Miao <eric.y.miao@gmail.com>
> Signed-off-by Jakob Viketoft <jakob.viketoft@bitsim.com>

Acked-by: Daniel Mack <daniel@caiaq.de>

Thanks,
Daniel

> --- a/arch/arm/mach-pxa/include/mach/colibri.h	2010-03-15
> 17:09:39.000000000 +0100
> +++ b/arch/arm/mach-pxa/include/mach/colibri.h	2010-04-16
> 13:53:29.000000000 +0200
> @@ -2,6 +2,7 @@
>  #define _COLIBRI_H_
> 
>  #include <net/ax88796.h>
> +#include <mach/mfp.h>
> 
>  /*
>   * common settings for all modules
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
