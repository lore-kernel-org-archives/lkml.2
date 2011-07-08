Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab1GHHq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 03:46:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10269 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab1GHHqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 03:46:55 -0400
X-AuditID: cbfee61a-b7c53ae000002dc1-f4-4e16b5e53c03
Date: Fri, 08 Jul 2011 16:46:32 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 1/2] cpufreq: exynos4210: make needlessly global symbols
 static
In-reply-to: <1310106044.27158.0.camel@phoenix>
To: "'Axel Lin'" <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: "'Dave Jones'" <davej@redhat.com>, cpufreq@vger.kernel.org
Message-id: <003101cc3d43$2f752010$8e5f6030$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=UTF-8
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acw9NzDpV9on/9DyQOqVLfCSPp6mqAAC9zAA
References: <1310106044.27158.0.camel@phoenix>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:
> 
> The following symbols are needlessly defined global:
>   exynos4_verify_speed
>   exynos4_getspeed
>   exynos4_set_clkdiv
> 
> Make them static.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Yes :)

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> ---
>  drivers/cpufreq/exynos4210-cpufreq.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/cpufreq/exynos4210-cpufreq.c b/drivers/cpufreq/exynos4210-
> cpufreq.c
> index 54025fc..b7c3a84 100644
> --- a/drivers/cpufreq/exynos4210-cpufreq.c
> +++ b/drivers/cpufreq/exynos4210-cpufreq.c
> @@ -191,17 +191,17 @@ static unsigned int
> exynos4_apll_pms_table[CPUFREQ_LEVEL_END] = {
>  	((200 << 16) | (6 << 8) | 4),
>  };
> 
> -int exynos4_verify_speed(struct cpufreq_policy *policy)
> +static int exynos4_verify_speed(struct cpufreq_policy *policy)
>  {
>  	return cpufreq_frequency_table_verify(policy, exynos4_freq_table);
>  }
> 
> -unsigned int exynos4_getspeed(unsigned int cpu)
> +static unsigned int exynos4_getspeed(unsigned int cpu)
>  {
>  	return clk_get_rate(cpu_clk) / 1000;
>  }
> 
> -void exynos4_set_clkdiv(unsigned int div_index)
> +static void exynos4_set_clkdiv(unsigned int div_index)
>  {
>  	unsigned int tmp;
> 
> --
> 1.7.4.1

