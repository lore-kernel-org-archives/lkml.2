Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab2K2GUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:20:38 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4925 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2K2GUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:20:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 28 Nov 2012 22:20:20 -0800
Message-ID: <50B6FEAD.9070401@nvidia.com>
Date: Thu, 29 Nov 2012 11:50:29 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sivaram Nair <sivaramn@nvidia.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] ARM: tegra: remove unused functions in mach/clk.h
References: <1353999553-5196-1-git-send-email-sivaramn@nvidia.com>
In-Reply-To: <1353999553-5196-1-git-send-email-sivaramn@nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 November 2012 12:29 PM, Sivaram Nair wrote:
> This is a cleaning up patch that removes couple of functions in
> mach/clk.h that are no longer used and does not have any body.
>
> Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
> ---
>   arch/arm/mach-tegra/include/mach/clk.h |    5 -----
>   1 file changed, 5 deletions(-)
>
> diff --git a/arch/arm/mach-tegra/include/mach/clk.h b/arch/arm/mach-tegra/include/mach/clk.h
> index 95f3a54..64d2657 100644
> --- a/arch/arm/mach-tegra/include/mach/clk.h
> +++ b/arch/arm/mach-tegra/include/mach/clk.h
> @@ -34,11 +34,6 @@ enum tegra_clk_ex_param {
>   void tegra_periph_reset_deassert(struct clk *c);
>   void tegra_periph_reset_assert(struct clk *c);
>   
> -#ifndef CONFIG_COMMON_CLK
> -unsigned long clk_get_rate_all_locked(struct clk *c);
> -#endif
> -
> -void tegra2_sdmmc_tap_delay(struct clk *c, int delay);
>   int tegra_clk_cfg_ex(struct clk *c, enum tegra_clk_ex_param p, u32 setting);
>   
>   #endif

Reviewed-by: Prashant Gaikwad <pgaikwad@nvidia.com>
