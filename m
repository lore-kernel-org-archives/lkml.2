Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396Ab2CWS1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 14:27:51 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:46515 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab2CWS1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 14:27:50 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+y7GCtGPyaqHGTUSjMciiO
Date: Fri, 23 Mar 2012 11:27:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: mathieu.poirier@linaro.org, Kevin Hilman <khilman@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 9/9] ARM: omap: select CPU_FREQ_TABLE where needed
Message-ID: <20120323182746.GF9859@atomide.com>
References: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
 <1332522836-29517-10-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332522836-29517-10-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* mathieu.poirier@linaro.org <mathieu.poirier@linaro.org> [120323 10:17]:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The omap platform requires CPU_FREQ_TABLE support to be enabled for its
> CPU_FREQ implementations, so automatically select that when CPU_FREQ
> is enabled.

I think this is also solved now, Kevin might be able to confirm this.

Regards,

Tony
 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
>  arch/arm/plat-omap/Kconfig |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
> index aa59f42..1983d16 100644
> --- a/arch/arm/plat-omap/Kconfig
> +++ b/arch/arm/plat-omap/Kconfig
> @@ -207,6 +207,11 @@ config OMAP_PM_NOOP
>  
>  endchoice
>  
> +config OMAP_CPU_FREQ
> +	def_bool "y"
> +	depends on CPU_FREQ
> +	select CPU_FREQ_TABLE
> +
>  endmenu
>  
>  endif
> -- 
> 1.7.5.4
> 
