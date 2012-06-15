Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab2FOABB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:01:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:34128 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050Ab2FOAAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:00:54 -0400
Date: Fri, 15 Jun 2012 02:00:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] tracing: Fix the outmost stupidity of tracing_off()
In-Reply-To: <1339717703.13377.285.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1206150154540.3086@ionos>
References: <alpine.LFD.2.02.1206142345100.3086@ionos>  <1339714725.13377.252.camel@gandalf.stny.rr.com>  <alpine.LFD.2.02.1206150106511.3086@ionos> <1339717703.13377.285.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012, Steven Rostedt wrote:
> On Fri, 2012-06-15 at 01:12 +0200, Thomas Gleixner wrote:
> 
> > That's still not an excuse for utter stupidity, really. Just check the
> > commit date vs. your discovery time.
> > 
> > I told you often enough to be more careful, but that one is really
> > beyond comprehension.
> 
> I'm really thinking that this was due to a bad push. As I believe I had
> stale code (made this fix locally, but pushed the broken branch) and all
> my changes were on top of it. When updating to the latest tip, I had
> code I didn't want to merge, or conflicts happened, that I ended up
> cherry-picking changes. Which breaks from my normal workflow, which is
> to make sure my old changes fast forward to tip before doing a rebase of
> my new code.
> 
> I have several branches that I work on and when they are ready, I rebase
> them on top of tip, run a bunch of tests, and then push them out.
> 
> I'm a heavy user of tracing_off() too, and since the development of my
> work is usually on older branches, I would not have noticed the bug. As
> after I get things working I usually rebase on top of tip before doing
> my final tests and asking for the pull request.

Bla, bla, bla.....

 commit 499e547057f5bba5cd6f87ebe59b05d0c59da905
 Author: Steven Rostedt <srostedt@redhat.com>
 Date:   Wed Feb 22 15:50:28 2012 -0500

Did you actually read what I wrote above?

> > That's still not an excuse for utter stupidity, really. Just check the
> > commit date vs. your discovery time.

Emphasis on discovery time.

Si tacuisses, philosophus mansisses

