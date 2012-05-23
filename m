Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212Ab2EWJ7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:59:34 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:33248 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2EWJ7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:59:32 -0400
Date: Wed, 23 May 2012 15:27:38 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH 3/3] tracing: Provide traceevents interface for uprobes
Message-ID: <20120523095738.GA15587@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120403010442.17852.9888.sendpatchset@srdronam.in.ibm.com>
 <20120403010502.17852.58528.sendpatchset@srdronam.in.ibm.com>
 <1337764783.13348.142.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1337764783.13348.142.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052309-5518-0000-0000-0000049C3040
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Implements trace_event support for uprobes. In its current form it can
> > be used to put probes at a specified offset in a file and dump the
> > required registers when the code flow reaches the probed address.
> > 
> > The following example shows how to dump the instruction pointer and %ax
> > a register at the probed text address.  Here we are trying to probe
> > zfree in /bin/zsh
> > 
> 
> Masami,
> 
> Can you ack this patch as well (only if you agree)
> 

Masami already acked the patches and its now part of the -tip tree.

https://lkml.org/lkml/2012/4/12/163
and 

http://lkml.org/lkml/2012/4/12/164

and 

https://lkml.org/lkml/2012/4/16/115


and these patches got picked into -tip  on May 7 

f3f096c tracing: Provide trace events interface for uprobes
8ab83f5 tracing: Extract out common code for kprobes/uprobes trace events
3a6b766 tracing: Modify is_delete, is_return from int to bool

-- 
Thanks and Regards
Srikar

