Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab1LEPsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 10:48:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47289 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421Ab1LEPsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 10:48:23 -0500
Date: Mon, 5 Dec 2011 16:46:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL 0/4] perf test improvements
Message-ID: <20111205154644.GE28866@elte.hu>
References: <1322842769-7232-1-git-send-email-acme@infradead.org>
 <4ED902C0.5020300@gmail.com>
 <20111202182214.GA4544@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111202182214.GA4544@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Em Fri, Dec 02, 2011 at 09:54:24AM -0700, David Ahern escreveu:
> > 
> > 
> > On 12/02/2011 09:19 AM, Arnaldo Carvalho de Melo wrote:
> > > Hi Ingo,
> > > 
> > >         Please consider pulling from:
> > > 
> > > git://github.com/acmel/linux.git perf/core
> > > 
> > > 	Now there are 29 outstanding changesets on this branch.
> > 
> > What about the 2 commits on your urgent branch? I don't recall seeing a
> > response that those were picked up, and they are not in Linus' branch.
> 
> Waiting for Ingo on those. If they don't get picked by 
> tomorrow I'll ask Linus directly.

It should now all be in -tip, will send it to Linus today or 
tomorrow.

Thanks,

	Ingo
