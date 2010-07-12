Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab0GLCUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 22:20:05 -0400
Received: from ozlabs.org ([203.10.76.45]:47114 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab0GLCUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 22:20:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] x86-64: software IRQ masking and handling
Date: Mon, 12 Jul 2010 11:49:57 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
References: <4C3A06E3.50402@kernel.org> <AANLkTik8EHarsrnAisuj9SKbeXddlA6Dz-KzDOPsmBxh@mail.gmail.com>
In-Reply-To: <AANLkTik8EHarsrnAisuj9SKbeXddlA6Dz-KzDOPsmBxh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007121149.58129.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 05:59:48 am Linus Torvalds wrote:
> On Sun, Jul 11, 2010 at 11:01 AM, Tejun Heo <tj@kernel.org> wrote:
> >
> > I just got it working and it behaves pretty good on qemu.  Actual
> > machines can't idle but seem to work otherwise.  I'll fix up idle, get
> > paravirt working and try to get some perf measurements but I'll be
> > mostly off next week, so it will take some time.  In the meantime,
> > what do you guys think?
> 
> You need to show some real improvement on real hardware.

Also, is it worth trying to implement this soft disable generically?
I know at least ppc64 does it today...

(Y'know, because your initial patch wasn't ambitious enough...)

It might reduce the use of NMIs.  But maybe not.

Cheers,
Rusty.
PS.  When did we start top-commenting and quoting the whole patch?
