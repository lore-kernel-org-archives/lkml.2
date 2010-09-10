Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0IJQpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:45:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36408 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973Ab0IJQpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:45:49 -0400
Date: Fri, 10 Sep 2010 18:45:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <htejun@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com
Subject: Re: [PATCH percpu#for-next] percpu: clear memory allocated with the
 km allocator
Message-ID: <20100910164525.GA11188@elte.hu>
References: <4c88dca1.44e7d80a.577e.3592@mx.google.com>
 <1284040322.2589.174.camel@edumazet-laptop>
 <AANLkTimHwiXa62GhHA0hQ0AOcDaxgqRcV+O63G_qoZW8@mail.gmail.com>
 <1284106566.402.26.camel@laptop>
 <4C89EF37.5080803@kernel.org>
 <4C89F1CE.4050302@gmail.com>
 <1284108918.402.31.camel@laptop>
 <20100910093115.2f0859af.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910093115.2f0859af.randy.dunlap@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Fri, 10 Sep 2010 10:55:18 +0200 Peter Zijlstra wrote:
> 
> > On Fri, 2010-09-10 at 10:52 +0200, Tejun Heo wrote:
> > > Percpu allocator should clear memory before returning it but the km
> > > allocator forgot to do it.  Fix it.
> > > 
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > Spotted-by: Peter Zijlstra <peterz@infradead.org>
> > 
> > (fwiw, -tip uses Reported-by)
> 
> fyi, Documentation/SubmittingPatches does also.

Yeah, and, FYI, there's observed strong correlation between the 
maintenance policies of -tip and Documentation/SubmittingPatches.
[i'd even venture so far to claim causation]

Thanks,

	Ingo
