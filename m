Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab1CPRcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:32:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab1CPRcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:32:31 -0400
From: Tom Tromey <tromey@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 0/20] 0: Inode based uprobes
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
	<20110314163028.a05cec49.akpm@linux-foundation.org>
	<20110314234754.GP2499@one.firstfloor.org>
	<alpine.LFD.2.00.1103150114590.2787@localhost6.localdomain6>
	<20110315180639.GQ2499@one.firstfloor.org>
	<alpine.LFD.2.00.1103152038280.2787@localhost6.localdomain6>
	<1300219261.9910.300.camel@gandalf.stny.rr.com>
	<alpine.LFD.2.00.1103152102430.2787@localhost6.localdomain6>
	<1300221856.9910.305.camel@gandalf.stny.rr.com>
X-Attribution: Tom
Date: Wed, 16 Mar 2011 11:32:06 -0600
In-Reply-To: <1300221856.9910.305.camel@gandalf.stny.rr.com> (Steven Rostedt's
	message of "Tue, 15 Mar 2011 16:44:16 -0400")
Message-ID: <m3lj0f2cq1.fsf@fleche.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve> I'm more interested in the perf/trace than gdb, as the way gdb is mostly
Steve> used (at least now) to debug problems in the code with a big hammer
Steve> (single step, look at registers/variables). That is, gdb is usually very
Steve> interactive and its best to "stop the code" from running to examine what
Steve> has happened. gdb is not something you will run on an application that
Steve> is being used by others.

It depends.  People do in fact do this stuff.  In recent years gdb got
its own implementation of "always inserted" breakpoints (basically the
same idea as uprobes) to support some trickier multi-thread debugging
scenarios.

Tom
