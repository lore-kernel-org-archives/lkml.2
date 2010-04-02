Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab0DBRcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:32:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46626 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687Ab0DBRcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:32:14 -0400
Date: Fri, 2 Apr 2010 19:32:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [GIT PULL v3] perf fixes
Message-ID: <20100402173203.GA11712@elte.hu>
References: <1270007927-6391-1-git-send-regression-fweisbec@gmail.com>
 <20100401071742.GB5207@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401071742.GB5207@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, Mar 31, 2010 at 05:58:45AM +0200, Frederic Weisbecker wrote:
> > Ingo,
> > 
> > Please pull the perf/urgent branch that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	perf/urgent
> 
> 
> I have updated the tree. There was a leftover patch for perf/core
> inside (not listed here). Also, since you've merged linus tree in
> perf/urgent lately, I've zapped my merge commit. Other than that,
> the three fixes remain.
> 
> Thanks.

Pulled, thanks Frederic!

Note, i also queued up this patch from Edwin:

  257ef9d: perf, x86: Fix callgraphs of 32-bit processes on 64-bit kernels

with your Acked-by added.

Thanks,

	Ingo
