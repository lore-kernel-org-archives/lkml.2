Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab1FNIJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 04:09:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40299 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321Ab1FNIJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 04:09:34 -0400
Date: Tue, 14 Jun 2011 10:09:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "trenn@novell.com" <trenn@novell.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [patch v4 1/2] stop_machine: enable __stop_machine() to be
 called from the cpu online path
Message-ID: <20110614080915.GD29900@elte.hu>
References: <20110613175832.331826123@sbsiddha-MOBL3.sc.intel.com>
 <20110613175915.504721985@sbsiddha-MOBL3.sc.intel.com>
 <20110613195613.GA11196@elte.hu>
 <1307998158.2682.33.camel@sbsiddha-MOBL3.sc.intel.com>
 <1307999142.2682.42.camel@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307999142.2682.42.camel@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Mon, 2011-06-13 at 13:49 -0700, Suresh Siddha wrote:
> > On Mon, 2011-06-13 at 12:56 -0700, Ingo Molnar wrote:
> > > * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > > 
> > > >  include/linux/stop_machine.h |   11 +++--
> > > >  kernel/stop_machine.c        |   91 ++++++++++++++++++++++++++++++++++++++++---
> > > >  2 files changed, 93 insertions(+), 9 deletions(-)
> > > 
> > > Btw., this is *way* too risky for a -stable backport.
> > > 
> > 
> > Ingo, we can have a smaller patch (appended) for the -stable. How do you
> > want to go ahead? Take this small patch for both mainline and -stable
> > and the two code cleanup/consolidation patches for -tip (to go into
> > 3.1?). Thanks.
> 
> oops. sent it too soon. fixed a !CONFIG_SMP compilation issue. 
> Updated simple patch appended.

See? It's by definition not a "simple" patch.

Thanks,

	Ingo
