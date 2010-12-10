Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab0LJIYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 03:24:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:5697 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595Ab0LJIYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 03:24:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,323,1288594800"; 
   d="scan'208";a="634996846"
Subject: Re: [RFC PATCH 2/3 v3] perf: Implement Nehalem uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1291922670.6803.47.camel@twins>
References: <1291267223.2405.314.camel@minggr.sh.intel.com>
	 <1291922670.6803.47.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 16:28:28 +0800
Message-ID: <1291969708.10384.52.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 03:24 +0800, Peter Zijlstra wrote:
> On Thu, 2010-12-02 at 13:20 +0800, Lin Ming wrote:
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> 
> > @@ -1362,6 +1357,7 @@ int __init init_hw_perf_events(void)
> >  
> >         switch (boot_cpu_data.x86_vendor) {
> >         case X86_VENDOR_INTEL:
> > +               init_uncore_pmu();
> >                 err = intel_pmu_init();
> >                 break;
> >         case X86_VENDOR_AMD: 
> 
> Since you're otherwise fully separated from the regular cpu driver,
> could you also grow your own early_initcall() ?

OK, will use early_initcall().


