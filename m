Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab1BQPsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:48:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52411 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab1BQPsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:48:10 -0500
Date: Thu, 17 Feb 2011 16:48:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Arvind R <arvino55@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.37 4/4] edac: i82975x driver revision change
In-Reply-To: <AANLkTi=-3GBLdM_dP5nb4s_pWR+-1KnN3F6ws1Enh2NP@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1102171647540.2160@pobox.suse.cz>
References: <AANLkTi=-3GBLdM_dP5nb4s_pWR+-1KnN3F6ws1Enh2NP@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011, Arvind R wrote:

> Subject: [PATCH 4/4] edac: i82975x driver revision change
> 
> bump up revision to reflect 3 patches
> 
> Signed-off-by: Arvind R. <arvino55@gmail.com>
> ---
>  i82975x_edac.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> ---
> diff -up a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
> --- a/drivers/edac/i82975x_edac.c
> +++ b/drivers/edac/i82975x_edac.c
> @@ -16,7 +16,7 @@
>  #include <linux/edac.h>
>  #include "edac_core.h"
> 
> -#define I82975X_REVISION	" Ver: 1.0.0 " __DATE__
> +#define I82975X_REVISION	" Ver: 1.0.3 " __DATE__
>  #define EDAC_MOD_STR		"i82975x_edac"
> 
>  #define i82975x_printk(level, fmt, arg...) \

Does that really matter since we have git?

How about dropping that completely?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
