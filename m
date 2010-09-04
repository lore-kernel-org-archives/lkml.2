Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0IDISV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 04:18:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47795 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab0IDIST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 04:18:19 -0400
Date: Sat, 4 Sep 2010 10:18:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Renninger <trenn@suse.de>, Jean Pihet <jean.pihet@newoldbits.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing, perf: add more power related events
Message-ID: <20100904081801.GA19876@elte.hu>
References: <AANLkTikvbn3+JPc7pnGZk-H4B71MHTu+-vjuzfJw_7PC@mail.gmail.com>
 <201009032005.08268.trenn@suse.de>
 <20100903195555.GA1663@elte.hu>
 <201009032210.08524.trenn@suse.de>
 <4C817D0E.6020702@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C817D0E.6020702@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0042]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> On 9/3/2010 1:10 PM, Thomas Renninger wrote:
> >
> >>- and check how existing tools like
> >>powertop make use of such events - and sync it all up.
> >Does powertop use these events?
> >
> 
> the next version will; I've already coded this stuff ;-)

Ok, so an Acked-by from you for the new tracepoints (once they are fully 
posted) would certainly be useful.

Thanks,

	Ingo
