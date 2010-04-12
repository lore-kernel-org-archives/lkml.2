Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab0DLTr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 15:47:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47036 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab0DLTrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 15:47:55 -0400
Date: Mon, 12 Apr 2010 20:47:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joe Perches <joe@perches.com>, Ben Dooks <ben-linux-arm@fluff.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/9] arch/arm: Fix continuation lines
Message-ID: <20100412194737.GS3048@n2100.arm.linux.org.uk>
References: <cover.1269655208.git.joe@perches.com> <0c97f736400ec243e71ba794ae7046a61d2449c1.1269655208.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c97f736400ec243e71ba794ae7046a61d2449c1.1269655208.git.joe@perches.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is Samsung stuff, it should be copied to Ben (added).

On Fri, Mar 26, 2010 at 07:27:50PM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/arm/mach-s5pv210/clock.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-s5pv210/clock.c b/arch/arm/mach-s5pv210/clock.c
> index ccccae2..a989c5e 100644
> --- a/arch/arm/mach-s5pv210/clock.c
> +++ b/arch/arm/mach-s5pv210/clock.c
> @@ -394,8 +394,8 @@ void __init_or_cpufreq s5pv210_setup_clocks(void)
>  	pclk83 = hclk166 / GET_DIV(clkdiv0, S5P_CLKDIV0_PCLK83);
>  	pclk66 = hclk133 / GET_DIV(clkdiv0, S5P_CLKDIV0_PCLK66);
>  
> -	printk(KERN_INFO "S5PV210: ARMCLK=%ld, HCLKM=%ld, HCLKD=%ld, \
> -			HCLKP=%ld, PCLKM=%ld, PCLKD=%ld, PCLKP=%ld\n",
> +	printk(KERN_INFO "S5PV210: ARMCLK=%ld, HCLKM=%ld, HCLKD=%ld, "
> +			"HCLKP=%ld, PCLKM=%ld, PCLKD=%ld, PCLKP=%ld\n",
>  	       armclk, hclk200, hclk166, hclk133, pclk100, pclk83, pclk66);
>  
>  	clk_fout_apll.rate = apll;
> -- 
> 1.7.0.14.g7e948
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
