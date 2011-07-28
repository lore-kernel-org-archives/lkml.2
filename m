Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1G1Jt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 05:49:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:54924 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab1G1JtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 05:49:22 -0400
Date: Thu, 28 Jul 2011 11:49:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yong Zhang <yong.zhang0@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [ANNOUNCE] 3.0-rt4
In-Reply-To: <20110728094159.GA24590@windriver.com>
Message-ID: <alpine.LFD.2.02.1107281147450.2660@ionos>
References: <alpine.LFD.2.02.1107272222420.2660@ionos> <20110728094159.GA24590@windriver.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1896718819-1311846560=:2660"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1896718819-1311846560=:2660
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 28 Jul 2011, Yong Zhang wrote:

> On Wed, Jul 27, 2011 at 11:37:09PM +0200, Thomas Gleixner wrote:
> > Dear RT Folks,
> > 
> > I'm pleased to announce the 3.0-rt4 release.
> > 
> 
> Building error if !PREEMPT_RT:
> 
>   CC      kernel/hrtimer.o
> kernel/hrtimer.c: In function ‘hrtimer_interrupt’:
> kernel/hrtimer.c:1459:27: error: ‘hrtimer_wakeup’ undeclared (first use in this function)
> kernel/hrtimer.c:1459:27: note: each undeclared identifier is reported only
>   once for each function it appears in
> make[1]: *** [kernel/hrtimer.o] Error 1
> 
> Patch is here and seems it could be scrolled into
> hrtimer-fixup-hrtimer-callback-changes-for-preempt-r.patch :)

Applied, thanks a lot !

     tglx
--8323328-1896718819-1311846560=:2660--
