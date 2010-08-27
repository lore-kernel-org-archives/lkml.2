Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab0H0SPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:15:12 -0400
Received: from www.tglx.de ([62.245.132.106]:57143 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab0H0SPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:15:09 -0400
Date: Fri, 27 Aug 2010 20:14:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 09/11] sched: timer-driven next buddy (update)
In-Reply-To: <20100827180241.GB22679@Krystal>
Message-ID: <alpine.LFD.2.00.1008272010070.2768@localhost.localdomain>
References: <20100826180908.648103531@efficios.com> <20100826181341.635603837@efficios.com> <20100827180241.GB22679@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Aug 2010, Mathieu Desnoyers wrote:

> Sorry, I forgot that I based this patchset on top of my LTTng tree all along, so
> this new patch version is needed for reject-less application of the patchset on
> a vanilla 2.6.35.2 tree.

That does not change my opinion on that much.

As I said before I strongly object to implement special handling for a
particular wakeup scenario as this will open a can of worms for all
other special cases and workloads.

Thanks,

	tglx



 
