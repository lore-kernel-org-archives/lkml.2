Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab1DVGKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 02:10:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58842 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab1DVGKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 02:10:45 -0400
Date: Fri, 22 Apr 2011 08:10:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/7] lockdep: Print a nice description of an irq locking
 issue
Message-ID: <20110422061030.GA13600@elte.hu>
References: <20110421014153.126662477@goodmis.org>
 <20110421014259.132728798@goodmis.org>
 <BANLkTimzhTqOXZ6BFGP68EB4Wqrx9OAH7Q@mail.gmail.com>
 <1303386029.7181.118.camel@gandalf.stny.rr.com>
 <20110421133541.GB2702@zhy>
 <1303395845.7181.127.camel@gandalf.stny.rr.com>
 <BANLkTikBk2n8x1gJBHHrpxZZrhEpVFxt4A@mail.gmail.com>
 <1303439684.7181.150.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303439684.7181.150.camel@gandalf.stny.rr.com>
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

> On Fri, 2011-04-22 at 09:41 +0800, Yong Zhang wrote:
> 
> > > I probably should modify the lockdep selftests to add an option to show
> > > the output as well as it triggers errors. This would allow me to make
> > > sure the output still works.
> > 
> > This does make sense to keep things consistent if we have it.
> 
> Actually, Peter informed me that we already do this. Just need to boot
> with debug_locks_verbose=1.

Yeah, that's been in lockdep since v1, that's how i prettified the original 
lockdep output.

Thanks,

	Ingo
