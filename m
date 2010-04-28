Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629Ab0D3Rt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:49:58 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51853 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933617Ab0D3Rtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:49:53 -0400
Date: Wed, 28 Apr 2010 08:08:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>,
       Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] arm/mach-msm: Add CONFIG conditional for board-trout
Message-ID: <20100428060825.GE3721@ucw.cz>
References: <201004290241.23068.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004290241.23068.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-04-29 02:41:22, Peter Huewe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch adds a conditional for CONFIG_MSM_DEBUG_UART to prevent a
> build failure[1], this is done the same way as for every board in mach-msm.
> 
> References:
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/2448102/
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Ack.


> ---
> KernelVersion: linux-next-20100429
> 
>  arch/arm/mach-msm/board-trout.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-msm/board-trout.c b/arch/arm/mach-msm/board-trout.c
> index 9793ff4..b88aec2 100644
> --- a/arch/arm/mach-msm/board-trout.c
> +++ b/arch/arm/mach-msm/board-trout.c
> @@ -82,8 +82,10 @@ static void __init trout_map_io(void)
>  }
>  
>  MACHINE_START(TROUT, "HTC Dream")
> +#ifdef CONFIG_MSM_DEBUG_UART
>  	.phys_io	= MSM_DEBUG_UART_PHYS,
>  	.io_pg_offst	= ((MSM_DEBUG_UART_BASE) >> 18) & 0xfffc,
> +#endif
>  	.boot_params	= 0x10000100,
>  	.fixup		= trout_fixup,
>  	.map_io		= trout_map_io,

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
