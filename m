Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab2ISHU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:20:56 -0400
Received: from void.printf.net ([89.145.121.20]:46970 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab2ISHUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:20:55 -0400
From: Chris Ball <cjb@laptop.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/5] mmc: msm_sdcc: Remove unnecessary include
References: <1348038044-1790-1-git-send-email-sboyd@codeaurora.org>
	<1348038044-1790-3-git-send-email-sboyd@codeaurora.org>
Date: Wed, 19 Sep 2012 03:21:17 -0400
In-Reply-To: <1348038044-1790-3-git-send-email-sboyd@codeaurora.org> (Stephen
	Boyd's message of "Wed, 19 Sep 2012 00:00:41 -0700")
Message-ID: <m3txuuh40i.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 19 2012, Stephen Boyd wrote:
> This driver has no reason to include msm_iomap.h. Remove it so
> that we can remove msm_iomap.h from include/mach in the future.
>
> Cc: Chris Ball <cjb@laptop.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/mmc/host/msm_sdcc.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
> index 1d14cda..8bcb330 100644
> --- a/drivers/mmc/host/msm_sdcc.c
> +++ b/drivers/mmc/host/msm_sdcc.c
> @@ -43,7 +43,6 @@
>  #include <asm/sizes.h>
>  
>  #include <mach/mmc.h>
> -#include <mach/msm_iomap.h>
>  #include <mach/dma.h>
>  #include <mach/clk.h>

Acked-by: Chris Ball <cjb@laptop.org>

Sending this via the MSM tree is fine.  Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
