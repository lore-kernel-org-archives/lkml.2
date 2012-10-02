Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab2JBK2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 06:28:30 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:40704 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab2JBK22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 06:28:28 -0400
Message-ID: <506AC19F.3000900@linux.vnet.ibm.com>
Date: Tue, 02 Oct 2012 15:57:43 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Shai Fultheim <shai@scalemp.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] x86/cache_info: use ARRAY_SIZE() in amd_l3_attrs()
References: <20121002083409.GM12398@elgon.mountain>
In-Reply-To: <20121002083409.GM12398@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12100210-8878-0000-0000-000004366573
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 02:04 PM, Dan Carpenter wrote:
> Using ARRAY_SIZE() is more readable.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat
 
> diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> index 9a7c90d..93c5451 100644
> --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> @@ -991,7 +991,7 @@ static struct attribute ** __cpuinit amd_l3_attrs(void)
>  	if (attrs)
>  		return attrs;
> 
> -	n = sizeof (default_attrs) / sizeof (struct attribute *);
> +	n = ARRAY_SIZE(default_attrs);
> 
>  	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
>  		n += 2;
> 

