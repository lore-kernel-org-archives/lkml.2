Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165Ab0FKIae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 04:30:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43505 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275Ab0FKIac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 04:30:32 -0400
Date: Fri, 11 Jun 2010 10:30:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
       rostedt@goodmis.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 03/13] jump label v9: x86 support
Message-ID: <20100611083028.GE6864@basil.fritz.box>
References: <cover.1276116186.git.jbaron@redhat.com> <c837d1a0a380030a4ea61acbcf0183518675a8ee.1276116186.git.jbaron@redhat.com> <1276171930.2077.200.camel@twins> <20100610121440.GA20130@elte.hu> <20100610132616.GA19561@basil.fritz.box> <20100610153742.GA9118@elte.hu> <20100610162453.GF19561@basil.fritz.box> <20100611081256.GA20217@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100611081256.GA20217@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What you are arguing for is a 'bloaty code generator by default' model and 
> that model sucks.

I am arguing for a "non sucky code by default" model.

It is widely known that "sucky code by default" sucks already,
that is why the big distros made their choice.

Anyways luckily the default is all config options so we don't need
to agree on this (and the best choice likely varies by workload
too)

> Possibly, but not without substantiating the rather vague statements you have 
> made so far.

Yes, more data with recent builds is needed for concrete changes.

BTW afaik the "icache over everything" model was never really
substantiated by all that much data either, just somehow
it became dogma.

I must say I was a bit burned by doing annotations -- i added
unlikely() originally and as far as I can see most unlikely()s
are quite useless today because they do nothing the compiler
doesn't do already so I would prefer to not repeat that.

So my personal preference is actually less annotations over more.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
