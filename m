Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1C2SVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 14:21:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33730 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab1C2SVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 14:21:44 -0400
Date: Tue, 29 Mar 2011 20:21:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH] lockdep: Print a nice description of an irq locking
 issue
Message-ID: <20110329182131.GB16244@elte.hu>
References: <1301418845.14261.284.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301418845.14261.284.camel@gandalf.stny.rr.com>
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

> After having to explain lockdep interrupt locking inversions a few
> times, I decided to have lockdep spit out the scenario that it is
> complaining about.

Looks very useful!

Would you be interested in extending this to other lockdep splats as well? 

"What does this mean" is a very common reaction to lockdep splats on lkml, and 
it's kind of silly that lockdep does not explain things better (like your patch 
does) - it has already done the much harder job of *proving* that a locking 
sequence is problematic :-)

	Ingo
