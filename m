Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1BWPZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:25:21 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59813 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab1BWPZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:25:16 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Watkins, Melissa" <m-watkins@ti.com>,
        "sachi@mistralsolutions.com" <sachi@mistralsolutions.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Chemparathy, Cyril" <cyril@ti.com>,
        Juha Kuikka <juha.kuikka@elektrobit.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Wed, 23 Feb 2011 20:54:52 +0530
Subject: RE: [PATCH 1/1] da830: macro rename DA8XX_LPSC0_DMAX to
 DA8XX_LPSC0_PRUSS.
Thread-Topic: [PATCH 1/1] da830: macro rename DA8XX_LPSC0_DMAX to
 DA8XX_LPSC0_PRUSS.
Thread-Index: AcvJ9IVGoMH2dRbyQkavQFCVaaoNDwJdM7EQ
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BE4916D@dbde02.ent.ti.com>
References: <1297433905-27925-1-git-send-email-subhasish@mistralsolutions.com>
In-Reply-To: <1297433905-27925-1-git-send-email-subhasish@mistralsolutions.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Subhasish,

Please add a "davinci: " prefix to the subject line of
mach-davinci patches. The patch is not really specific
to DA830.

On Fri, Feb 11, 2011 at 19:48:25, Subhasish Ghosh wrote:
> The PRUSS was named as DMAX on da830 platform.
> This patch resolves the naming conflict by replacing the macro
> DA8XX_LPSC0_DMAX with DA8XX_LPSC0_PRUSS.

This description is inaccurate. Firstly, there is no naming
conflict. DMAX is an internal name for the module which is
known as PRUSS in TI public documentation. This patch just
gets the code in sync with TI documentation.

Can you please update the subject and re-spin this patch?

Thanks,
Sekhar

> 
> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
> ---
>  arch/arm/mach-davinci/da830.c            |    2 +-
>  arch/arm/mach-davinci/include/mach/psc.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/da830.c b/arch/arm/mach-davinci/da830.c
> index ec23ab4..0577a5d 100644
> --- a/arch/arm/mach-davinci/da830.c
> +++ b/arch/arm/mach-davinci/da830.c
> @@ -148,7 +148,7 @@ static struct clk scr2_ss_clk = {
>  static struct clk dmax_clk = {
>  	.name		= "dmax",
>  	.parent		= &pll0_sysclk2,
> -	.lpsc		= DA8XX_LPSC0_DMAX,
> +	.lpsc		= DA8XX_LPSC0_PRUSS,
>  	.flags		= ALWAYS_ENABLED,
>  };
>  
> diff --git a/arch/arm/mach-davinci/include/mach/psc.h b/arch/arm/mach-davinci/include/mach/psc.h
> index 62b0858..a47e6f2 100644
> --- a/arch/arm/mach-davinci/include/mach/psc.h
> +++ b/arch/arm/mach-davinci/include/mach/psc.h
> @@ -150,7 +150,7 @@
>  #define DA8XX_LPSC0_SCR0_SS		10
>  #define DA8XX_LPSC0_SCR1_SS		11
>  #define DA8XX_LPSC0_SCR2_SS		12
> -#define DA8XX_LPSC0_DMAX		13
> +#define DA8XX_LPSC0_PRUSS		13
>  #define DA8XX_LPSC0_ARM			14
>  #define DA8XX_LPSC0_GEM			15
>  
> -- 
> 1.7.2.3
> 
> 

