Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab2I0BdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 21:33:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:54290 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab2I0BdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 21:33:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,492,1344236400"; 
   d="scan'208";a="213995623"
Message-ID: <5063ACDB.8090203@intel.com>
Date: Thu, 27 Sep 2012 09:33:15 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [BUG] perf/x86: Intel uncore_pmu_to_box() local variable typo
References: <CABPqkBQkXtBKJUQX1czwyVAFMvro4akvfpAvLyStPLzntdZhuQ@mail.gmail.com>
In-Reply-To: <CABPqkBQkXtBKJUQX1czwyVAFMvro4akvfpAvLyStPLzntdZhuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 06:44 PM, Stephane Eranian wrote:
> Hi,
> 
> I don't understand why the local variable box needs to
> be declared static here:
> 
> static struct intel_uncore_box *
> uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
> {
>         static struct intel_uncore_box *box;
> 
>         box = *per_cpu_ptr(pmu->box, cpu);
>         if (box)
>                 return box;
>         ....
> }
> 

My fault, sorry
