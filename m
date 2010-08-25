Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab0HYKl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 06:41:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60317 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab0HYKlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 06:41:55 -0400
Date: Wed, 25 Aug 2010 12:41:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100825104130.GA27891@elte.hu>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100825094819.GB3198@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100825094819.GB3198@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0469]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> On 20.08.10 11:25:10, Ingo Molnar wrote:
> 
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > >
> > > >it's not working so well, i'm getting:
> > > >
> > > > Uhhuh. NMI received for unknown reason 00 on CPU 9.
> > > > Do you have a strange power saving mode enabled?
> > > > Dazed and confused, but trying to continue
> > > >
> > > >on a nehalem box, after a perf top and perf stat run.
> > 
> > FYI, it does not trigger on an AMD box.
> 
> Ingo,
> 
> do you mean it does not trigger false positives on AMD? [...]

Correct, on AMD boxes i do not get this message during the first 'perf 
top' run:

> > > > Uhhuh. NMI received for unknown reason 00 on CPU 9.
> > > > Do you have a strange power saving mode enabled?
> > > > Dazed and confused, but trying to continue

Before the two patches i did not get these messages at all, on any of 
the systems.

> You might use the debug patch below for diagnostics.

Thanks, will try that and report back.

	Ingo
