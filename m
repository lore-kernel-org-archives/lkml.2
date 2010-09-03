Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab0ICT4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 15:56:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56942 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005Ab0ICT4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 15:56:09 -0400
Date: Fri, 3 Sep 2010 21:55:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Renninger <trenn@suse.de>
Cc: Jean Pihet <jean.pihet@newoldbits.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        Arjan Van De Ven <arjan@linux.intel.com>, arjan@infradead.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing, perf: add more power related events
Message-ID: <20100903195555.GA1663@elte.hu>
References: <AANLkTikvbn3+JPc7pnGZk-H4B71MHTu+-vjuzfJw_7PC@mail.gmail.com>
 <AANLkTinaBJqY0UaMnwJa0nfeNYDm2Dw2t_pBsoGsraHL@mail.gmail.com>
 <AANLkTikg70zAHyA9pcWybz7SsQSPOuzUeuBdwX1cs+MP@mail.gmail.com>
 <201009032005.08268.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009032005.08268.trenn@suse.de>
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


* Thomas Renninger <trenn@suse.de> wrote:

> Hi Jean,
> 
> Summary at the beginning if people stop reading on the details
> below...:
> Nice work!
> You have my vote to get this merged.
> I think it's up to Ingo to push it.

Well, the patch that got posted:

  [PATCH] tracing, perf: add more power related events

Only adds tracepoints to power.h, but doesnt actually use them anywhere 
...

Is there a companion patch i missed?

Also, it would be nice to add it to x86 and to OMAP at once, and 
synchronize up all the power events - and check how existing tools like 
powertop make use of such events - and sync it all up. We dont want to 
have inconsistent, architecture-dependent events in the end, for obvious 
reasons.

Thanks,

	Ingo
