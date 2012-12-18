Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab2LRVlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:41:22 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36984 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071Ab2LRVlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:41:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Youquan Song <youquan.song@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86,idle: pr_debug information need separated
Date: Tue, 18 Dec 2012 22:46:31 +0100
Message-ID: <2211955.SJfKpfzytl@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1355851562-28407-1-git-send-email-youquan.song@intel.com>
References: <1355851562-28407-1-git-send-email-youquan.song@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 18, 2012 12:26:02 PM Youquan Song wrote:
> When debug kernel, the the below information is found:
> intel_idle: unaware of model 0x1a MWAIT 4 please contact lenb@kernel.orgACPI: Device input0 -> No ACPI support
> 
> so this patch separates it.

Applied to linux-pm.git/linux-next as v3.8 material.

Thanks,
Rafael


> Signed-off-by: Youquan Song <youquan.song@intel.com>
> ---
>  drivers/idle/intel_idle.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index b0f6b4c..eae6e3b 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -518,7 +518,7 @@ static int intel_idle_cpuidle_driver_init(void)
>  			if (*cpuidle_state_table[cstate].name == '\0')
>  				pr_debug(PREFIX "unaware of model 0x%x"
>  					" MWAIT %d please"
> -					" contact lenb@kernel.org",
> +					" contact lenb@kernel.org\n",
>  				boot_cpu_data.x86_model, cstate);
>  			continue;
>  		}
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
