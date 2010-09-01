Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab0IALH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 07:07:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58290 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab0IALHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 07:07:24 -0400
Date: Wed, 1 Sep 2010 13:07:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, kvm-devel <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ftrace/perf_event leak
Message-ID: <20100901110706.GA7709@elte.hu>
References: <4C7E11E5.1040402@redhat.com>
 <1283331868.2059.808.camel@laptop>
 <4C7E1C36.6070400@redhat.com>
 <4C7E1F12.8030304@cn.fujitsu.com>
 <4C7E2D1D.3080603@redhat.com>
 <1283338977.2059.938.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283338977.2059.938.camel@laptop>
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

> On Wed, 2010-09-01 at 13:38 +0300, Avi Kivity wrote:
> > On 09/01/2010 12:38 PM, Li Zefan wrote:
> > >
> > > Then try this:
> > 
> > Tested-by: Avi Kivity <avi@redhat.com>
> > 
> 
> Thanks, queued as:
> 
> ---
> Subject: perf, trace: Fix module leak
> From: Li Zefan <lizf@cn.fujitsu.com>
> Date: Wed Sep 01 12:58:43 CEST 2010
> 
> Commit 1c024eca (perf, trace: Optimize tracepoints by using
> per-tracepoint-per-cpu hlist to track events) caused a module refcount
> leak.
> 
> Tested-by: Avi Kivity <avi@redhat.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <4C7E1F12.8030304@cn.fujitsu.com>

Do we need this for -stable too?

	Ingo
