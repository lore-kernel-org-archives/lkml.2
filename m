Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab1EJP3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 11:29:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45127 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756596Ab1EJP3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 11:29:24 -0400
Date: Tue, 10 May 2011 17:29:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf events, x86: Implement Sandybridge last-level cache
 events
Message-ID: <20110510152911.GB25705@elte.hu>
References: <1304930382.3924.303.camel@minggr.sh.intel.com>
 <1305022112.2914.40.camel@laptop>
 <1305037078.2226.18.camel@localhost>
 <1305037772.2914.88.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305037772.2914.88.camel@laptop>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2011-05-10 at 22:17 +0800, Lin Ming wrote:
> > 
> > I'm also not sure if the bits combination do count exactly
> > L3_HIT/_MISS.
> > 
> <snip manual bits>
> 
> > May need some micro-benchmarks to verify it. 
> 
> either that or ask for clarification internally.

Well, please run micro-benchmarks to verify it in any case! Having more 
clarification than that will also be useful.

Thanks,

	Ingo
