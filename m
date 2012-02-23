Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab2BWR0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:26:00 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10017 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab2BWRZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:25:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 23 Feb 2012 09:25:36 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        "Nicolas Pitre (nico@fluxnic.net)" <nico@fluxnic.net>,
        "Russell King - ARM Linux (linux@arm.linux.org.uk)" 
	<linux@arm.linux.org.uk>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 23 Feb 2012 09:25:34 -0800
Subject: RE: [PATCH] ARM: tegra: Enable CPUIdle on Tegra20
Thread-Topic: [PATCH] ARM: tegra: Enable CPUIdle on Tegra20
Thread-Index: AczyRy6QjMybq7iySo+GW41xseCTJAACJS8w
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC9AB@HQMAIL01.nvidia.com>
References: <1330014056-26125-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1330014056-26125-1-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Thursday, February 23, 2012 9:21 AM:
> As the LP3 code also works for Tegra20, we can enable cpuidle for Tegra20.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>

Note that the commit which added this line appears to have been made in
Nicolas's idle branch, which was merged into Russell's for-armsoc branch.
This presumably impacts the path through which this fix should get merged.

(hence leaving the patch below for Nicolas/Russell to see)

> ---
>  arch/arm/mach-tegra/common.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
> index e2a2c1f..2f86fcc 100644
> --- a/arch/arm/mach-tegra/common.c
> +++ b/arch/arm/mach-tegra/common.c
> @@ -113,8 +113,6 @@ static void __init tegra_init_cache(u32 tag_latency, u32 data_latency)
>  #ifdef CONFIG_ARCH_TEGRA_2x_SOC
>  void __init tegra20_init_early(void)
>  {
> -	disable_hlt();  /* idle WFI usage needs to be confirmed */
> -
>  	tegra_init_fuse();
>  	tegra2_init_clocks();
>  	tegra_clk_init_from_table(tegra20_clk_init_table);
> --
> 1.7.7.rc0.72.g4b5ea.dirty

-- 
nvpublic

