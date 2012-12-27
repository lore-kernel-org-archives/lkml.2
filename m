Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085Ab2L0FME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 00:12:04 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1328 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2L0FMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 00:12:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 26 Dec 2012 21:12:00 -0800
Message-ID: <50DBD896.8040706@nvidia.com>
Date: Thu, 27 Dec 2012 10:41:50 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/6 v9] arm: use devicetree to get smp_twd clock
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <1354833773-22845-1-git-send-email-mark.langsdorf@calxeda.com> <1354833773-22845-2-git-send-email-mark.langsdorf@calxeda.com>
In-Reply-To: <1354833773-22845-2-git-send-email-mark.langsdorf@calxeda.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 December 2012 04:12 AM, Mark Langsdorf wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> ---
> Changes from v4, v5, v6, v7, v8
>          None.
> Changes from v3
>          No longer setting *clk to NULL in twd_get_clock().
> Changes from v2
>          Turned the check for the node pointer into an if-then-else statement.
>          Removed the second, redundant clk_get_rate.
> Changes from v1
>          None.
>
>   arch/arm/kernel/smp_twd.c | 19 +++++++++++--------
>   1 file changed, 11 insertions(+), 8 deletions(-)

Hi Mark,

What is the status of this patch?

Regards,
PrashantG

> diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
> index b22d700..af46b80 100644
> --- a/arch/arm/kernel/smp_twd.c
> +++ b/arch/arm/kernel/smp_twd.c
> @@ -237,12 +237,15 @@ static irqreturn_t twd_handler(int irq, void *dev_id)
>   	return IRQ_NONE;
>   }
>

