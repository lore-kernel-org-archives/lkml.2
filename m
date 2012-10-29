Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab2J2TmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 15:42:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:6802 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532Ab2J2TmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 15:42:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,673,1344236400"; 
   d="scan'208";a="234212215"
Date: Mon, 29 Oct 2012 12:42:03 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, ming.m.lin@intel.com
Subject: Re: [Patch v1 04/10] perf/x86: add memory profiling via PEBS Load
 Latency
Message-ID: <20121029194203.GK2266@tassilo.jf.intel.com>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
 <1351523752-4215-5-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351523752-4215-5-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +struct attribute *nhm_events_attrs[] = {
> +	EVENT_PTR(CPU_CYCLES),
> +	EVENT_PTR(INSTRUCTIONS),
> +	EVENT_PTR(CACHE_REFERENCES),
> +	EVENT_PTR(CACHE_MISSES),
> +	EVENT_PTR(BRANCH_INSTRUCTIONS),
> +	EVENT_PTR(BRANCH_MISSES),
> +	EVENT_PTR(BUS_CYCLES),
> +	EVENT_PTR(STALLED_CYCLES_FRONTEND),
> +	EVENT_PTR(STALLED_CYCLES_BACKEND),
> +	EVENT_PTR(REF_CPU_CYCLES),
> +	EVENT_PTR(mem_ld_nhm),
> +	NULL,
> +};

I thought Jiri's patch already exports all the generic ones?

Why do you need to replace the whole table?

BTW I still think my approach in the v4 Haswell patchkit 
is simpler and didn't rely on hardcoding these events.

-Andi
