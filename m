Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab0FCTb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:31:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39204 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab0FCTb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:31:28 -0400
Date: Thu, 3 Jun 2010 21:30:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: tytso@mit.edu
Cc: Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
       Arve Hj?nnev?g <arve@android.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: suspend blockers & Android integration
Message-ID: <20100603193045.GA7188@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2612]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tytso@mit.edu <tytso@mit.edu> wrote:

> [...] Not only has the source code been made available, but hundreds of 
> engineering hours have been made trying to accomodate the demands of LKML 
> --- and LKML has said no to suspend blockers/wakelocks.

I dont think you are being fair here, at all.

Firstly, the suspend-blockers feature is not being rejected (fixing and 
extending suspend is a worthwile goal), it's just that various different 
schemes have been proposed by the people who'll eventually have to maintain 
that code down the line.

Those reasons seem justified and they are based in praxis that have solved 
similar problems to what Android tries to solve.

Sadly the response from the Android team has been 100% uncompromising: either 
suspend blockers or nothing.

The thing is, if the insertion of 'hundreds of man hours' into discussing a 
feature was technical grounds for upstream inclusion then we'd today have a 
Linux kernel with:

 - STREAMS
 - a kABI
 - modularized ipv4
 - perfmon
 - two dozen CPU schedulers
 - zero-copy stupidly pushed to all the file APIs

... and IMO we'd be off much worse technically.

Lets realize it, Linux is an engineering effort that has literally cost about 
ten thousand man years. That's about a _85 million_ man hours. It takes effort 
to keep that kind of work valuable!

Also, why did the Android team start its contributions with such a difficult 
and controversial kernel feature?

There is absolutely _zero_ technical reason why the Android team should 
present this as as an all-or-nothing effort. Why not merge hw drivers first 
(with suspend blockers commented or stubbed out), to reduce the fork distance?

Really, i myself have controversial kernel features pending all the time. They 
dont go upstream for a few kernel releases - over a year sometimes - and 
sometimes they never go upstream.

But the fact that some feature of mine is pending doesnt give me the right to 
go away sulking, it doesnt mean i will block the whole flow of patches in 
retaliation (as you seem to suggest Google will now have the right to do) - i 
simply try to work it out.

Lets be reasonable and work it all out, ok?

Thanks,

	Ingo
