Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0IQQYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 12:24:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46119 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab0IQQYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 12:24:37 -0400
Date: Fri, 17 Sep 2010 18:24:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Renninger <trenn@suse.de>
Cc: Jean Pihet <jean.pihet@newoldbits.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
Subject: Re: [PATCH] tracing, perf: add more power related events
Message-ID: <20100917162412.GB3341@elte.hu>
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
 <AANLkTi=W_Lo2m=hkA2F48oUziqGzt4Tr8y6KhfgqRnbz@mail.gmail.com>
 <20100917142459.GA28124@elte.hu>
 <201009171736.14170.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009171736.14170.trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Renninger <trenn@suse.de> wrote:

> On Friday 17 September 2010 16:24:59 Ingo Molnar wrote:
> > 
> > * Jean Pihet <jean.pihet@newoldbits.com> wrote:
> > 
> > > > Apropos documentation..., are the power trace events documented
> > > > somewhere?
> > >
> > > No. We need something like Documentation/trace/events-kmem.txt. I
> > > can write that with for the new power API.
> > Such a patch introducing events-power.txt would be most welcome!
> Better wait a bit...
> As soon as it exists, things are harder to change.
> As long as there isn't an API documented, there doesn't exist one
> (yes we want to have perf timechart, etc. still functional/compatible,
> but still, better let's do not the same mistake with some quick shots).

Music to my ears ;-) I was waiting for ACPI side feedback to all this, 
so whatever we do it would be nice to cover ARM and x86 as well - and in 
a single coherent framework.

[ You dont even have to document it, as good code is self-explanatory ;-) ]

Thanks,

	Ingo
