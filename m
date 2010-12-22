Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab0LVKPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 05:15:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55933 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab0LVKPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:15:03 -0500
Date: Wed, 22 Dec 2010 11:14:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] perf: Add load latency monitoring on Intel
 Nehalem/Westmere
Message-ID: <20101222101443.GA1640@elte.hu>
References: <1293005543.2565.156.camel@minggr.sh.intel.com>
 <1293006808.2170.42.camel@laptop>
 <1293008656.2170.67.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293008656.2170.67.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-12-22 at 09:33 +0100, Peter Zijlstra wrote:
> > On Wed, 2010-12-22 at 16:12 +0800, Lin Ming wrote:
> > > It's applied on top of tip/master(3ea1f4f89) and Andi's offcore
> > > patchsets are needed. 
> > 
> > I still haven't gotten a version of that I'm willing to apply.
> 
> That is, maybe you could pick up his patches and finish them, Andi
> doesn't seem interested in getting them sorted.

FYI, this one of Peter's reviews that went unaddressed:

  https://lkml.org/lkml/2010/12/1/213

and he got no reply to that feedback in the past 3 weeks. (There may be other issues 
outstanding, i have not checked.)

Thanks,

	Ingo
