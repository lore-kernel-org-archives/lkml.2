Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab1GFJfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 05:35:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50731 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248Ab1GFJfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 05:35:15 -0400
Date: Wed, 6 Jul 2011 11:35:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Lin Ming <ming.m.lin@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] perf, x86: Add Intel Nehalem/Westmere uncore pmu
Message-ID: <20110706093501.GA11969@elte.hu>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
 <1309421396-17438-2-git-send-email-ming.m.lin@intel.com>
 <20110630165849.GE23059@one.firstfloor.org>
 <1309761541.18875.40.camel@minggr.sh.intel.com>
 <20110704215706.GH15637@one.firstfloor.org>
 <1309864954.3282.61.camel@twins>
 <cf54fbb6e05ab86a5c6029eda70012e4.squirrel@www.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf54fbb6e05ab86a5c6029eda70012e4.squirrel@www.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> 
> >
> >>   But it's not strictly required I would say,
> >> 44(?) bits are probably enough for near all use cases.
> >
> > 44bits is in the hours range for pure cycle counts, which is 
> > so-so. I bet you're going to be very annoyed when you find your 
> > counters are wrecked after your 5 hour test run finishes.
> 
> For these kinds of long running measurements you usually care about 
> ratios, not absolutes. Some infrequent wrapping should not 
> substantially change. those.

That's just empty blathering - those who *do* take a look at 
long-running absolute values obviously care.

There's absolutely no reason to be sloppy here - this needs to be 
implemented correctly.

Thanks,

	Ingo
