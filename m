Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2BAJiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 04:38:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59480 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917Ab2BAJiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 04:38:19 -0500
Date: Wed, 1 Feb 2012 08:09:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
Message-ID: <20120201070917.GA7495@elte.hu>
References: <1327585945.22710.87.camel@gandalf.stny.rr.com>
 <20120126135504.GA13107@elte.hu>
 <1327586669.22710.89.camel@gandalf.stny.rr.com>
 <1327588606.22710.100.camel@gandalf.stny.rr.com>
 <20120126183946.GA14709@elte.hu>
 <87ehuldf0m.fsf@rustcorp.com.au>
 <1327924333.22710.157.camel@gandalf.stny.rr.com>
 <87sjiwjzew.fsf@rustcorp.com.au>
 <20120131122016.GF32010@elte.hu>
 <87lionjr41.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lionjr41.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Tue, 31 Jan 2012 13:20:16 +0100, Ingo Molnar <mingo@elte.hu> wrote:
>
> > > Wow, we're really bikeshedding this!
> > 
> > Hey, I don't think this is bikesheddig: we are shedding 
> > *kilobytes* of code from pretty hot codepaths, that kind of 
> > topic does deserve some detailed attention :-)
> 
> I agree, but we put the bloat in without this much discussion 
> :)

Hey, it was eventually noticed :-)

Would be nice if linux-next posted a daily before/after commit 
bloatometer stats top list - unfortunately this would be pretty 
time consuming to acquire due to the many rebasing Git trees. 

With a proper Git workflow enforced it would be a few dozen 
kernel builds per release, easily done on a fast enough box.

Thanks,

	Ingo
