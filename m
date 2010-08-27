Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0H0TX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 15:23:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53947 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab0H0TX1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 15:23:27 -0400
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20100827183240.GC22679@Krystal>
References: <20100826180908.648103531@efficios.com>
	 <1282849045.1975.1587.camel@laptop>
	 <alpine.LFD.2.00.1008262306140.2768@localhost.localdomain>
	 <alpine.LFD.2.00.1008270013390.2768@localhost.localdomain>
	 <20100826230934.GA4194@Krystal> <1282894655.1975.1650.camel@laptop>
	 <20100827152125.GB14926@Krystal> <1282923686.1975.2780.camel@laptop>
	 <20100827160946.GG14926@Krystal> <1282930072.1975.2962.camel@laptop>
	 <20100827183240.GC22679@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Aug 2010 21:23:14 +0200
Message-ID: <1282936994.1975.3119.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 14:32 -0400, Mathieu Desnoyers wrote:
> 
> These are problems you get only when you allow spawning any number of threads.
> If, instead, you create a thread pool at timer creation, then you can allow
> concurrency without problems with spawner context and error proparation.

That would be a massive resource waste for the normal case where the
interval > handler runtime.


