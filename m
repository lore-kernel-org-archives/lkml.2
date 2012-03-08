Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab2CHMTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 07:19:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45320 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab2CHMTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 07:19:41 -0500
Date: Thu, 8 Mar 2012 13:19:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf script: Add script to collect and display IBS
 samples
Message-ID: <20120308121924.GA19674@elte.hu>
References: <20111223103329.GC4749@elte.hu>
 <20111223111958.GE16765@erda.amd.com>
 <20111223135340.GB21382@elte.hu>
 <1324649698.24803.55.camel@twins>
 <20111223144040.GB2297@elte.hu>
 <20111223161701.GF16765@erda.amd.com>
 <20111223163930.GA5983@elte.hu>
 <20111223165030.GG16765@erda.amd.com>
 <20111230095521.GA12077@elte.hu>
 <20120202112133.GR16322@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202112133.GR16322@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> > To help your effort we could tentatively put the patches 
> > into a separate tip:perf/ibs topic branch if everyone agrees 
> > otherwise, which can go upstream once it's complete and 
> > usable.
> 
> This would be very helpful for me. So far I see following 
> patches for this on top of today's tip/perf/core (623ec99):
> 
> 08e232d perf, x86: Implement IBS event configuration
> 05efba4 perf, x86: Implement IBS interrupt handler
> b0532b2 perf, x86: Implement IBS pmu control ops
> 56ccf1a perf, x86: Implement 64 bit counter support for IBS
> 98e655c perf tool: Parse general/raw events from sysfs
> aac22da perf tools: Add pmu mappings to header information
> f1f062d perf script: Add script to collect and display IBS samples

I've applied the following 4 kernel patches to perf/x86-ibs:

 db98c5faf8cb: perf/x86: Implement 64-bit counter support for IBS
 4db2e8e6500d: perf/x86: Implement IBS pmu control ops
 b7074f1fbd61: perf/x86: Implement IBS interrupt handler
 510419435c69: perf/x86: Implement IBS event configuration

and pushed it out.

We can apply any tooling changes to this branch as well.

I suspect being able to skid-less profile on AMD CPUs, using 
IBS, would be a useful feature to users. What would be required 
for that to work?

Thanks,

	Ingo
