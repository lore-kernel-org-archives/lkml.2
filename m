Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab2BQI6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 03:58:14 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45600 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab2BQI6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 03:58:09 -0500
Message-ID: <4F3E1683.8040703@linux.vnet.ibm.com>
Date: Fri, 17 Feb 2012 14:27:39 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Marcos Paulo de Souza <marcos.mage@gmail.com>
CC: lenb@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/idle/intel_idle.c: Fix confusing code identation
References: <1329468198-5887-1-git-send-email-marcos.mage@gmail.com>
In-Reply-To: <1329468198-5887-1-git-send-email-marcos.mage@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12021622-0260-0000-0000-0000008E1318
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2012 02:13 PM, Marcos Paulo de Souza wrote:

> Suggested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
> ---


Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

[ A small commit message wouldn't hurt though :-) ]

Regards,
Srivatsa S. Bhat

>  drivers/idle/intel_idle.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 54ab97b..5e71b98 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -495,8 +495,7 @@ int intel_idle_cpu_init(int cpu)
>  		int num_substates;
> 
>  		if (cstate > max_cstate) {
> -			printk(PREFIX "max_cstate %d reached\n",
> -			       max_cstate);
> +			printk(PREFIX "max_cstate %d reached\n", max_cstate);
>  			break;
>  		}
> 
> @@ -512,8 +511,9 @@ int intel_idle_cpu_init(int cpu)
>  		dev->states_usage[dev->state_count].driver_data =
>  			(void *)get_driver_data(cstate);
> 
> -			dev->state_count += 1;
> -		}
> +		dev->state_count += 1;
> +	}
> +
>  	dev->cpu = cpu;
> 
>  	if (cpuidle_register_device(dev)) {

