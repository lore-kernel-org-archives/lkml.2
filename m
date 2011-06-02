Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787Ab1FBJFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 05:05:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54279 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab1FBJFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 05:05:19 -0400
Date: Thu, 2 Jun 2011 11:05:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 4/6] MAINTAINERS: Remove unused PERFORMANCE EVENTS pattern
Message-ID: <20110602090509.GB7800@elte.hu>
References: <cover.1306950701.git.joe@perches.com>
 <8d1e596980a6b6fec79432bb5a5953985cf85c2f.1306950701.git.joe@perches.com>
 <20110602074057.GE2150@elte.hu>
 <1307003167.32125.59.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307003167.32125.59.camel@Joe-Laptop>
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


* Joe Perches <joe@perches.com> wrote:

> On Thu, 2011-06-02 at 09:40 +0200, Ingo Molnar wrote:
> > * Joe Perches <joe@perches.com> wrote:
> > > No arch/*/lib/perf_event* files exist so remove the pattern.
> > The arch/*/lib/ hierarchy is a common place to put stuff into, it 
> > does not hurt at all to have it mentioned.
> 
> Every once in awhile I run a script on MAINTAINERS
> and fix up defects found by the script.
>
> Dead code is dead code.
> This was unused as of commit e360adbe2924.

NAK, i've outlined my reasons:

 - It's an obvious pattern to put librarized functionality in there
   and should an architecture grow a file there in the future it
   will be included automatically.

 - What we are interested in are false positives (files included that
   should not be matched) and false negatives (files belonging to a
   subsystm not included) - this pattern is none of those.

> > stop mucking with these patterns and start dealing with some of 
> > the more important problems we have?
> 
> My time, my choice on what to do with it.

Yes, but this time you are also wasting my time with such a stupid 
patch, so it's not just your time wasted anymore.

Thanks,

	Ingo
