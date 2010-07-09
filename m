Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab0GIKR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 06:17:27 -0400
Received: from ozlabs.org ([203.10.76.45]:58040 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284Ab0GIKRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 06:17:25 -0400
Date: Fri, 9 Jul 2010 20:17:03 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 10/13] perf: Per PMU disable
Message-ID: <20100709101703.GR7771@brick.ozlabs.ibm.com>
References: <20100709082117.631541128@chello.nl>
 <20100709083248.156796575@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100709083248.156796575@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 10:21:27AM +0200, Peter Zijlstra wrote:

> -void hw_perf_disable(void)
> +static void powerpc_pmu_pmu_disable(struct pmu *pmu)

> -void hw_perf_enable(void)
> +static void powerpc_pmu_pmu_enable(struct pmu *pmu)

>  struct pmu power_pmu = {
> -	.event_init	= power_pmu_event_init,
> +	.pmu_enable	= power_pmu_pmu_enable,
> +	.pmu_disable	= power_pmu_pmu_disable,
> +	.event_init	= pmwer_pmu_event_init,

Doh!  Think you posted the old version of the patch again...

:)

Paul.
