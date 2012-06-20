Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab2FTNTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:19:23 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50280 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab2FTNTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:19:22 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/TLjEhUKmdqaWOEwNsJ1+F
Date: Wed, 20 Jun 2012 06:19:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: mathieu.poirier@linaro.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH] arm: OMAP depends on MMU
Message-ID: <20120620131918.GJ12766@atomide.com>
References: <1339116651-18051-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339116651-18051-1-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* mathieu.poirier@linaro.org <mathieu.poirier@linaro.org> [120607 17:55]:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> There is no way to build OMAP kernels without an MMU
> at this point because of dependencies on MMU-only functions.
> 
> As long as nobody is interested in fixing this, let's just disable
> this platforms for nommu kernels.

Thanks, applying into fixes non-critical.

Tony

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 84449dd..4b1fc0d 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -934,6 +934,7 @@ config ARCH_DAVINCI
>  
>  config ARCH_OMAP
>  	bool "TI OMAP"
> +	depends on MMU
>  	select HAVE_CLK
>  	select ARCH_REQUIRE_GPIOLIB
>  	select ARCH_HAS_CPUFREQ
> -- 
> 1.7.5.4
> 
