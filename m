Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab2GWKRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 06:17:32 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:52393 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab2GWKRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 06:17:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH] [CPUFREQ] conservative: Initialise the cpu field of the this_dbs_info
Date: Mon, 23 Jul 2012 12:23:04 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org, amit.kachhap@linaro.org,
        linux-kernel@vger.kernel.org
References: <1343028920-4712-1-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1343028920-4712-1-git-send-email-amit.daniel@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207231223.04620.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 23, 2012, Amit Daniel Kachhap wrote:
> This patch initialises the cpu field of this_dbs_info structure. This
> change is similar to existing ondemand governor.

Why do you think the change is needed?

Rafael


> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/cpufreq/cpufreq_conservative.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
> index 235a340..a1563d7 100644
> --- a/drivers/cpufreq/cpufreq_conservative.c
> +++ b/drivers/cpufreq/cpufreq_conservative.c
> @@ -504,6 +504,7 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  				j_dbs_info->prev_cpu_nice =
>  						kcpustat_cpu(j).cpustat[CPUTIME_NICE];
>  		}
> +		this_dbs_info->cpu = cpu;
>  		this_dbs_info->down_skip = 0;
>  		this_dbs_info->requested_freq = policy->cur;
>  
> 

