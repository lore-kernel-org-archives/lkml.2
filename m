Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab0LJIYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 03:24:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:18100 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401Ab0LJIYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 03:24:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,323,1288594800"; 
   d="scan'208";a="866670209"
Subject: Re: [RFC PATCH 2/3 v3] perf: Implement Nehalem uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1291922467.6803.44.camel@twins>
References: <1291267223.2405.314.camel@minggr.sh.intel.com>
	 <1291922467.6803.44.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 16:28:03 +0800
Message-ID: <1291969683.10384.51.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 03:21 +0800, Peter Zijlstra wrote:
> On Thu, 2010-12-02 at 13:20 +0800, Lin Ming wrote:
> > +       /* Check CPUID signatures: 06_1AH, 06_1EH, 06_1FH */
> > +       family = boot_cpu_data.x86;
> > +       model = boot_cpu_data.x86_model;
> > +       if (family != 6 || (model != 0x1A && model != 0x1E && model != 0x1F))
> > +               return; 
> 
> So that's 26, 30 and 31? Curiously
> arch/x86/kernel/cpu/perf_event_intel.c does have 31.
> 
> Also, could you match the style from perf_event_intel.c?

OK.


