Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3AECGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 21:06:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:23318 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545Ab3AECGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 21:06:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,413,1355126400"; 
   d="scan'208";a="270146694"
Date: Sat, 5 Jan 2013 09:12:55 -0500
From: Youquan Song <youquan.song@linux.intel.com>
To: Youquan Song <youquan.song@intel.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        mingo@kernel.org, Stephane Eranian <eranian@google.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86,perf: Add IvyBridge EP support
Message-ID: <20130105141255.GA32169@linux-youquan.bj.intel.com>
References: <1355851223-27705-1-git-send-email-youquan.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355851223-27705-1-git-send-email-youquan.song@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Would you like to take it? It is needed by Linux OSVs.

Thanks
-Youquan

On Tue, Dec 18, 2012 at 12:20:23PM -0500, Youquan Song wrote:
> Run in perf utility at Ivybridge EP server, encouter "not supported" event
> 
>    <not supported> L1-dcache-loads         
>    <not supported> L1-dcache-load-misses   
>    <not supported> L1-dcache-stores        
>    <not supported> L1-dcache-store-misses  
>    <not supported> L1-dcache-prefetches    
>    <not supported> L1-dcache-prefetch-misses
> 
> This patch add the support for this processor.
> 
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Youquan Song <youquan.song@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 324bb52..aea3503 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -2075,6 +2075,7 @@ __init int intel_pmu_init(void)
>  		pr_cont("SandyBridge events, ");
>  		break;
>  	case 58: /* IvyBridge */
> +	case 62: /* IvyBridge EP */
>  		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
>  		       sizeof(hw_cache_event_ids));
>  		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
> -- 
> 1.6.4.2
> 
 
