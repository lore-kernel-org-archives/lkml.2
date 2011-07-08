Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab1GHHsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 03:48:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11178 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1GHHsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 03:48:05 -0400
X-AuditID: cbfee61b-b7bfdae000006d51-5b-4e16b6248a20
Date: Fri, 08 Jul 2011 16:47:34 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 2/2] cpufreq: s5pv210: make needlessly global symbols static
In-reply-to: <1310106276.27158.2.camel@phoenix>
To: "'Axel Lin'" <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: "'Dave Jones'" <davej@redhat.com>, cpufreq@vger.kernel.org
Message-id: <003201cc3d43$54b12360$fe136a20$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=UTF-8
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acw9N7lo8/dOnCGVQuuGarZP7WfbnAAC3BQA
References: <1310106044.27158.0.camel@phoenix>
 <1310106276.27158.2.camel@phoenix>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:
> 
> The following symbols are needlessly defined global:
>   s5pv210_verify_speed
>   s5pv210_getspeed
> 
> Make them static.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> ---
>  drivers/cpufreq/s5pv210-cpufreq.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
> index a7cb338..806408e 100644
> --- a/drivers/cpufreq/s5pv210-cpufreq.c
> +++ b/drivers/cpufreq/s5pv210-cpufreq.c
> @@ -121,7 +121,7 @@ static void s5pv210_set_refresh(enum s5pv210_dmc_port
> ch, unsigned long freq)
>  	__raw_writel(tmp1, reg);
>  }
> 
> -int s5pv210_verify_speed(struct cpufreq_policy *policy)
> +static int s5pv210_verify_speed(struct cpufreq_policy *policy)
>  {
>  	if (policy->cpu)
>  		return -EINVAL;
> @@ -129,7 +129,7 @@ int s5pv210_verify_speed(struct cpufreq_policy *policy)
>  	return cpufreq_frequency_table_verify(policy, s5pv210_freq_table);
>  }
> 
> -unsigned int s5pv210_getspeed(unsigned int cpu)
> +static unsigned int s5pv210_getspeed(unsigned int cpu)
>  {
>  	if (cpu)
>  		return 0;
> --
> 1.7.4.1

