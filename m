Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0IQOZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 10:25:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45521 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab0IQOZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 10:25:19 -0400
Date: Fri, 17 Sep 2010 16:24:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jean Pihet <jean.pihet@newoldbits.com>
Cc: Thomas Renninger <trenn@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
Subject: Re: [PATCH] tracing, perf: add more power related events
Message-ID: <20100917142459.GA28124@elte.hu>
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
 <20100909075403.GA10798@elte.hu>
 <AANLkTimCy8pB6JZ2bkGutTou8-oXc1yjweqCxVrLw=Kk@mail.gmail.com>
 <201009171508.46471.trenn@suse.de>
 <AANLkTi=W_Lo2m=hkA2F48oUziqGzt4Tr8y6KhfgqRnbz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=W_Lo2m=hkA2F48oUziqGzt4Tr8y6KhfgqRnbz@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0436]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jean Pihet <jean.pihet@newoldbits.com> wrote:

> > Apropos documentation..., are the power trace events documented
> > somewhere?
>
> No. We need something like Documentation/trace/events-kmem.txt. I can 
> write that with for the new power API.

Such a patch introducing events-power.txt would be most welcome!

	Ingo
