Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab1EJHjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:39:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33427 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626Ab1EJHjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:39:43 -0400
Date: Tue, 10 May 2011 09:39:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Sharp <dhsharp@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
Message-ID: <20110510073931.GI11595@elte.hu>
References: <4DC45537.6070609@linux.intel.com>
 <1304713252.25414.2532.camel@gandalf.stny.rr.com>
 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
 <20110507065803.GA23414@elte.hu>
 <1304765110.25414.2564.camel@gandalf.stny.rr.com>
 <20110507144402.GC2859@elte.hu>
 <1304788829.11129.57.camel@frodo>
 <BANLkTik3CKw=tTtfqhDxR6f39_7kCLnUEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTik3CKw=tTtfqhDxR6f39_7kCLnUEA@mail.gmail.com>
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


* David Sharp <dhsharp@google.com> wrote:

> I believe it's been suggested that trace-cmd should be part of the kernel 
> tree, just like the perf tool. This would be nice, and would more easily 
> allow them to share this parsing code. It would also give them a common place 
> to work on their unification.

Thomas and me has done some work on providing that functionality, see the 
tip:perf/trace2 branch:

  http://people.redhat.com/mingo/tip.git/README

Do 'trace -a' to do system-wide tracing. It still needs quite some work, help 
is welcome :)

Thanks,

	Ingo
