Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235Ab1D2QuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 12:50:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43420 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970Ab1D2QuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 12:50:05 -0400
Date: Fri, 29 Apr 2011 18:49:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
Message-ID: <20110429164951.GB25491@elte.hu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
 <20110429152736.GA6517@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110429152736.GA6517@tassilo.jf.intel.com>
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


* Andi Kleen <ak@linux.intel.com> wrote:

> On Fri, Apr 29, 2011 at 11:04:46AM -0400, Vince Weaver wrote:
> > Hello Linus
> > 
> > can you revert the commit b52c55c6a25e4515b5e075a989ff346fc251ed09
> 
> Acked-by: Andi Kleen <ak@linux.intel.com>

I outlined my objections in my reply to Vince.

> (I wrote the original patch)
> 
> > (finally!) added in the 2.6.39 merge window.  However this is a useful 
> > feature and many tools (including the PAPI performance counter library 
> > that I work on) had added support for it in anticipation of the 2.6.39 
> 
> I also use some tools which benefit from this functionality. The extended raw 
> events are very useful to analyze NUMA problems for once.

Mind sharing those methods and help generalizing them and help making them 
useful to non-experts? Peter's patch which adds a 'NUMA' level to the cache 
event abstractions could be a good start.

Only once generalization has been covered sufficiently, once we are sure we can 
stick with the raw ABI, can we push that upstream.

Thanks,

	Ingo
