Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab0JUIWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:22:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46037 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab0JUIWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:22:44 -0400
Date: Thu, 21 Oct 2010 10:22:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: tmhikaru@gmail.com
Cc: Peter Zijlstra <peterz@infradead.org>, Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101021082233.GD8775@elte.hu>
References: <20100929070153.GA2200@brouette>
 <20101014145813.GA2185@brouette>
 <20101020132732.GA30024@brouette>
 <1287581440.3488.16.camel@twins>
 <1287582208.3488.20.camel@twins>
 <1287584073.3488.22.camel@twins>
 <1287595605.3488.52.camel@twins>
 <20101021014843.GA21295@roll>
 <20101021015337.GA21384@roll>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021015337.GA21384@roll>
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


* tmhikaru@gmail.com <tmhikaru@gmail.com> wrote:

> On Wed, Oct 20, 2010 at 09:48:43PM -0400, tm@ wrote:
> > On Wed, Oct 20, 2010 at 07:26:45PM +0200, Peter Zijlstra wrote:
> > > 
> > > 
> > > OK, how does this work for people? I find my idle load is still a tad
> > > high, but maybe I'm not patient enough.
> > 
> > I haven't had a chance to keep up with the topic, and I apologize. I'll be
> > testing this as soon as I can finish compiling it. Thank you all for not
> > letting this go unfixed.
> > 
> > Tim McGrath
> 
> Uhh, problem. This patch does not apply to git checkout
> 74f5187ac873042f502227701ed1727e7c5fbfa9
> 
> which is the version of the kernel that first exhibits this flaw.
> 
> which version of the kernel does this patch apply cleanly to?

Try -tip (which includes the scheduler development tree as well):

   http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
