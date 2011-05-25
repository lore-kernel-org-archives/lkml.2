Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1EYTGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:06:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34222 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010Ab1EYTGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:06:20 -0400
Date: Wed, 25 May 2011 21:06:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <kees.cook@canonical.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
Message-ID: <20110525190602.GC17864@elte.hu>
References: <1305807728.11267.25.camel@gandalf.stny.rr.com>
 <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com>
 <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
 <1306254027.18455.47.camel@twins>
 <20110524195435.GC27634@elte.hu>
 <alpine.LFD.2.02.1105242239230.3078@ionos>
 <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos>
 <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> And per-system-call permissions are very dubious. What system calls 
> don't you want to succeed? That ioctl? You just made it impossible 
> to do a modern graphical application. Yet the kind of thing where 
> we would _want_ to help users is in making it easier to sandbox 
> something like the adobe flash player. But without accelerated 
> direct rendering, that's not going to fly, is it?

I was under the impression that Will had a very specific application 
in mind which actually works today and uses the inferior version of 
seccomp.

Will, mind filling us in on that?

I'd agree that adding any of this without a real serious app making 
real use of it would be pointless. I discussed this under the 
impression that the app existed :-)

I also got the very distinct impression from the various iterations 
that a real usecase existed behind it - all the fixes and 
considerations looked very realistic, not designed up for security's 
sake.

> So I'm sorry for throwing cold water on you guys, but the whole 
> "let's come up with a new security gadget" thing just makes me go 
> "oh no, not again".

Fair enough :-)

Thanks,

	Ingo
