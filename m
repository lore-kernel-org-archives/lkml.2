Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab2KFNbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:31:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:64759 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab2KFNbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:31:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,722,1344236400"; 
   d="scan'208";a="165060709"
Date: Tue, 6 Nov 2012 05:31:35 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v2 08/16] perf/x86: add memory profiling via PEBS Load
 Latency
Message-ID: <20121106133135.GC25167@tassilo.jf.intel.com>
References: <1352123463-7346-1-git-send-email-eranian@google.com>
 <1352123463-7346-9-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352123463-7346-9-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +EVENT_ATTR(cpu-cycles,			CPU_CYCLES		);
> +EVENT_ATTR(instructions,		INSTRUCTIONS		);
> +EVENT_ATTR(cache-references,		CACHE_REFERENCES	);
> +EVENT_ATTR(cache-misses,		CACHE_MISSES		);
> +EVENT_ATTR(branch-instructions,		BRANCH_INSTRUCTIONS	);
> +EVENT_ATTR(branch-misses,		BRANCH_MISSES		);
> +EVENT_ATTR(bus-cycles,			BUS_CYCLES		);
> +EVENT_ATTR(stalled-cycles-frontend,	STALLED_CYCLES_FRONTEND	);
> +EVENT_ATTR(stalled-cycles-backend,	STALLED_CYCLES_BACKEND	);
> +EVENT_ATTR(ref-cycles,			REF_CPU_CYCLES		);

The merge_events() approach from the Haswell patches should be far cleaner

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
