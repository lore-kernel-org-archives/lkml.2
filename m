Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab0HBGtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 02:49:11 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:42380 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab0HBGtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 02:49:09 -0400
Date: Mon, 2 Aug 2010 12:16:38 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCHv10 2.6.35-rc6-tip 9/14]  trace: uprobes trace_event
 interface
Message-ID: <20100802064638.GB22812@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
 <20100727111045.24690.31897.sendpatchset@localhost6.localdomain6>
 <4C510BCE.4010704@hitachi.com>
 <20100802022055.GB5581@nowhere>
 <4C563F44.9080300@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4C563F44.9080300@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > In fact this could be a menu "Dynamic Probes", perhaps default off, inside
> > which Kprobes and Uprobes would be default on (but depend on "Dynamic Probes").
> > 
> > So that you can quickly enable them all in one.
> 
> Hmm, I disagree with it, because both Kprobes and Uprobes provides
> APIs for modules too.
> 
> I'd like to suggest below config tree
> 
> Kenrel hacking
>   - Kprobes
>   - Uprobes
>   - Tracing
>      -- Dynamic Events
>         depends on Kprobes || Uprobes
> or
> 	select Kprobes && Uprobes

I would agree with Masami since there could be people who might be
apprehensive to try out Uprobes (which would still be experimental) but
would be interested to use kprobes only since its more mature.

One change I would suggest would be to select respective events(i.e
kprobe_event, uprobe_event) instead of kprobes and uprobes.
	
-
Thanks and Regards
Srikar
