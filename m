Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1B1JIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:08:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43628 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab1B1JIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:08:42 -0500
Date: Mon, 28 Feb 2011 10:08:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 -tip] perf: x86, add SandyBridge support
Message-ID: <20110228090833.GA7439@elte.hu>
References: <1298877772.4937.25.camel@minggr.sh.intel.com>
 <AANLkTimAkCtPwEMzHM3A_=kWs+HbYMJ_OBvxcHo46RJg@mail.gmail.com>
 <1298883087.4937.42.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298883087.4937.42.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lin Ming <ming.m.lin@intel.com> wrote:

> > In other words, bit 0-3 of the umask cannot be zero.
> 
> I got the umask from "Table 30-20. PEBS Performance Events for Intel 
> microarchitecture code name Sandy Bridge".
> 
> But from "Table A-2. Non-Architectural Performance Events In the Processor Core 
> for Intel Core Processor 2xxx Series", the combinations are needed as you show 
> above.
> 
> Which one is correct?

Since you have access to the hardware, could you please test and see it in practice 
which one is correct?

Thanks,

	Ingo
