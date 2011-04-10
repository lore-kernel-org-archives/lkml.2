Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab1DJPIE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 11:08:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720Ab1DJPIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 11:08:02 -0400
Date: Sun, 10 Apr 2011 08:08:00 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Remove bouncing author email from arch/arm/plat-iop/time.c
 (fwd)
In-Reply-To: <alpine.LNX.2.00.1103150242040.26293@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1104082007200.6392@deuxcents.site>
References: <alpine.LNX.2.00.1103150242040.26293@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011, Jesper Juhl wrote:

> Mr. Deepak Saxena's email address, listed at the head of 
> arch/arm/plat-iop/time.c, bounces. Remove it.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  time.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/plat-iop/time.c b/arch/arm/plat-iop/time.c
> index 07f23bb..af6139d 100644
> --- a/arch/arm/plat-iop/time.c
> +++ b/arch/arm/plat-iop/time.c
> @@ -3,7 +3,7 @@
>   *
>   * Timer code for IOP32x and IOP33x based systems
>   *
> - * Author: Deepak Saxena <dsaxena@mvista.com>
> + * Author: Deepak Saxena
>   *
>   * Copyright 2002-2003 MontaVista Software Inc.
>   *

I'd still like to have Deepak's Acked-by before applying this. Adding to 
CC.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

