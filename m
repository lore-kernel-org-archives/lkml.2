Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030484Ab2AFTTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 14:19:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45564 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464Ab2AFTTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 14:19:14 -0500
Date: Fri, 6 Jan 2012 20:17:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andreas Schwab <schwab@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] scheduler changes for v3.3
Message-ID: <20120106191706.GB4164@elte.hu>
References: <20120105140846.GA32342@elte.hu>
 <CA+55aFwNzNSd2B57XYLC5r9sg=+GD=dP-UPZQDxmLXyLODS6+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwNzNSd2B57XYLC5r9sg=+GD=dP-UPZQDxmLXyLODS6+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [...] Also double-check my resolve of the 
> set_cpu_sd_state_idle() call in kernel/time/tick-sched.c, 
> please. I've pushed it out, and it seems to work for me, 
> but...

Looks good at first sight - set_cpu_sd_state_idle() is only 
called from the idle thread when it is going idle - so there 
should neither be any irq context callers nor any preemption 
going on - no races.

Thanks,

	Ingo
