Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1EQNay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:30:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40212 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489Ab1EQNax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:30:53 -0400
Date: Tue, 17 May 2011 15:30:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
Message-ID: <20110517133031.GA16689@elte.hu>
References: <1304788829.11129.57.camel@frodo>
 <20110507190033.GA11465@elte.hu>
 <1304996847.2969.151.camel@frodo>
 <20110510084158.GC27426@elte.hu>
 <1305032797.2943.34.camel@frodo>
 <20110511215111.GA16355@elte.hu>
 <BANLkTikRX2gNwyUSWLNBcpc727Ww7Ya6Ow@mail.gmail.com>
 <1305631152.5456.665.camel@gandalf.stny.rr.com>
 <4DD2771E.70106@gmail.com>
 <1305638829.5456.725.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305638829.5456.725.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 2011-05-17 at 07:24 -0600, David Ahern wrote:
> 
> > libparsevent or libperf? If you really meant libperf will it be a
> > superset of the event parsing -- like the inclusion of the plugins infra?
> > 
> 
> Yes, although not all the plugin infrastructure was in libparsevent.so.

Please post the patches in a finegrained manner that makes it easy to review 
each aspect of it.

Thanks,

	Ingo
