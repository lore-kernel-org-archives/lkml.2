Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab1CBIO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:14:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46873 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab1CBIO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:14:58 -0500
Date: Wed, 2 Mar 2011 09:14:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: Lin Ming <ming.m.lin@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "perfmon2-devel@lists.sf.net" <perfmon2-devel@lists.sf.net>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "acme@redhat.com" <acme@redhat.com>
Subject: Re: [PATCH] perf_events: update PEBS event constraints (v2)
Message-ID: <20110302081430.GE15665@elte.hu>
References: <4d6d636b.98a1df0a.15d8.57d1@mx.google.com>
 <1299027401.4937.106.camel@minggr.sh.intel.com>
 <AANLkTimkAuDQOW8J=vqcz-7r9gaN_=qq1=guBh6n6A7u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimkAuDQOW8J=vqcz-7r9gaN_=qq1=guBh6n6A7u@mail.gmail.com>
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


* Stephane Eranian <eranian@google.com> wrote:

> On Wed, Mar 2, 2011 at 1:56 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> > On Wed, 2011-03-02 at 04:20 +0800, Stephane Eranian wrote:
> >> This patch updates PEBS event constraints for Intel Atom, Nehalem, Westmere.
> >>
> >> This patch also reorganizes the PEBS format/constraint detection code. It is
> >> now based on processor model and not PEBS format. Two processors may use the
> >> same PEBS format without have the same list of PEBS events.
> >>
> >> In this second version, we simplified the initialization of the PEBS constraints
> >> by leveraging the existing switch() statement in perf_event_intel.c. We also
> >> renamed the constraint tables to be more consistent with regular constraints.
> >
> > Hi, Stephane
> >
> > Nice updates.
> > Wondering where did you get these PEBS event constraints? I didn't find
> > these in the latest manual.
> >
> Yeah, the manual is lacking some information. The other source of information
> is the PTU event files (whatif.intel.com).

Plus i suspect you have performed testing on affected CPUs as well?

If yes then i think we want to push these fixes via perf/urgent - they seem to 
nicely round up the constraints.

Thanks,

	Ingo
