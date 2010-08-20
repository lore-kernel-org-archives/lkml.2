Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab0HTPZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:25:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43049 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab0HTPZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:25:25 -0400
Date: Fri, 20 Aug 2010 17:25:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100820152510.GA4167@elte.hu>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
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


* Don Zickus <dzickus@redhat.com> wrote:

> I'll test tip later today to see if I can reproduce it.
> 
> Cheers,
> Don
> 
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> >
> >it's not working so well, i'm getting:
> >
> > Uhhuh. NMI received for unknown reason 00 on CPU 9.
> > Do you have a strange power saving mode enabled?
> > Dazed and confused, but trying to continue
> >
> >on a nehalem box, after a perf top and perf stat run.

FYI, it does not trigger on an AMD box.

Thanks,

	Ingo
