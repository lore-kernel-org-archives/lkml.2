Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1EQLTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 07:19:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49942 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab1EQLTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 07:19:14 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=UZYI7n2t75YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VIZvPYwb1djQpyPiT6cA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
From: Steven Rostedt <rostedt@goodmis.org>
To: Michael Rubin <mrubin@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <BANLkTikRX2gNwyUSWLNBcpc727Ww7Ya6Ow@mail.gmail.com>
References: <1304713252.25414.2532.camel@gandalf.stny.rr.com>
	 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
	 <20110507065803.GA23414@elte.hu>
	 <1304765110.25414.2564.camel@gandalf.stny.rr.com>
	 <20110507144402.GC2859@elte.hu> <1304788829.11129.57.camel@frodo>
	 <20110507190033.GA11465@elte.hu> <1304996847.2969.151.camel@frodo>
	 <20110510084158.GC27426@elte.hu> <1305032797.2943.34.camel@frodo>
	 <20110511215111.GA16355@elte.hu>
	 <BANLkTikRX2gNwyUSWLNBcpc727Ww7Ya6Ow@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 May 2011 07:19:12 -0400
Message-ID: <1305631152.5456.665.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 00:15 -0700, Michael Rubin wrote:

> What is the plan for customers going forward? Is it going to involve
> removing ftrace in favor for perf? Removing perf in favor for ftrace?
> We love perf and don't want to see it go away either.  We tend to use
> the two systems differently. Do customers basically have to wait a few
> years to see not only which system wins but which ones stays on top?

My plan is:

1) get libperf.so out for user tools to use.

2) Start hacking on code again :)

But I'll make sure that this will not be a burden on Google. There's no
reason that Google should be punished for using something that is
mainline, and using the proper ABIs. The code in ftrace is very flexible
and tools that use ftrace should still work even if we make internal
changes.

I'll work closely with you to make sure that Google's tools will always
work with future kernels.

> 
> I apologize if this is obvious to others but I am confused.

No need to apologize, it's a very confusing situation.

-- Steve


