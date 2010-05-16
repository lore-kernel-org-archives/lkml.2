Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0EPH4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 03:56:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52418 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab0EPH4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 03:56:19 -0400
Date: Sun, 16 May 2010 09:56:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] Lockup detector build fixes
Message-ID: <20100516075605.GA15391@elte.hu>
References: <20100515073732.GA17120@elte.hu>
 <1273977240-30800-1-git-send-regression-fweisbec@gmail.com>
 <20100516023648.GD7645@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100516023648.GD7645@nowhere>
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

> On Sun, May 16, 2010 at 04:33:56AM +0200, Frederic Weisbecker wrote:
> > Ingo,
> > 
> > Please pull the perf/nmi branch that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	perf/nmi
> > 
> > Thanks,
> > 	Frederic
> 
> 
> Tested on x86 and Sparc 64 with and without 
> CONFIG_LOCKUP_DETECTOR. No problem so far. Tell me 
> if you find any.

Looks good so far. Pulled, thanks Frederic!

	Ingo
