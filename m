Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab1G1Rns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 13:43:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:36267 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab1G1Rnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 13:43:46 -0400
Date: Thu, 28 Jul 2011 19:43:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [ANNOUNCE] 3.0-rt4
In-Reply-To: <20110728174123.GA10751@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1107281942580.2660@ionos>
References: <alpine.LFD.2.02.1107272222420.2660@ionos> <20110728174123.GA10751@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 28 Jul 2011, Paul E. McKenney wrote:

> On Wed, Jul 27, 2011 at 11:37:09PM +0200, Thomas Gleixner wrote:
> > Dear RT Folks,
> > 
> > I'm pleased to announce the 3.0-rt4 release.
> 
> 3.0-rt5 boots single-CPU under KVM on a 32-bit laptop.  Also with "-smp
> 2".  It even survived a minute or so of rcutorture in both cases.  ;-)
> 
> Some weirdness with interactivity -- if the system is idle aside from
> rcutorture, the rcutorture.stat_interval console messages don't come
> out unless I hit "enter" on the console.  But if I run "top", they do
> come out regularly.  Might well be KVM's fault, except that running
> rcutorture on non-rt kernels doesn't exhibit this behavior.

Nah, that's my lazy "avoid printing from atomic context" hack :)
 
> I guess I should try RCU_BOOST=y, then...

Good luck :)

