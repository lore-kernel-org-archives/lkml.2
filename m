Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab0IXW76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 18:59:58 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51378 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab0IXW75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 18:59:57 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+R8raV/MlbZuqju9Y7UB76
Date: Fri, 24 Sep 2010 15:59:58 -0700
From: Tony Lindgren <tony@atomide.com>
To: Tim Nordell <tim.nordell@logicpd.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] ARM: OMAP3LOGIC: Adding low-level debug support
Message-ID: <20100924225957.GM4211@atomide.com>
References: <1285358338-3403-1-git-send-email-tim.nordell@logicpd.com>
 <1285358338-3403-6-git-send-email-tim.nordell@logicpd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285358338-3403-6-git-send-email-tim.nordell@logicpd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tim Nordell <tim.nordell@logicpd.com> [100924 13:08]:
> Defined UART1 as the low-level debug port for both the
> omap3530_lv_som board and the omap3_torpedo board.

Ah the DEBUG_LL support is here, please merge this one into
the first patch.

Thanks,

Tony
 
> Signed-off-by: Tim Nordell <tim.nordell@logicpd.com>
> ---
>  arch/arm/plat-omap/include/plat/uncompress.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/include/plat/uncompress.h b/arch/arm/plat-omap/include/plat/uncompress.h
> index ddf723b..ff9f3a2 100644
> --- a/arch/arm/plat-omap/include/plat/uncompress.h
> +++ b/arch/arm/plat-omap/include/plat/uncompress.h
> @@ -139,6 +139,8 @@ static inline void __arch_decomp_setup(unsigned long arch_id)
>  		DEBUG_LL_OMAP2(1, omap3evm);
>  		DEBUG_LL_OMAP3(1, omap_3430sdp);
>  		DEBUG_LL_OMAP3(1, omap_3630sdp);
> +		DEBUG_LL_OMAP3(1, omap3530_lv_som);
> +		DEBUG_LL_OMAP3(1, omap3_torpedo);
>  
>  		/* omap3 based boards using UART3 */
>  		DEBUG_LL_OMAP3(3, cm_t35);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
