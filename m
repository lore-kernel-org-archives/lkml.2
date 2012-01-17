Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab2AQLMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 06:12:48 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:58168 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2AQLMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 06:12:47 -0500
Date: Tue, 17 Jan 2012 16:33:45 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v9 3.2 7/9] tracing: uprobes trace_event interface
Message-ID: <20120117110345.GC15447@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120110114821.17610.9188.sendpatchset@srdronam.in.ibm.com>
 <20120110114943.17610.28293.sendpatchset@srdronam.in.ibm.com>
 <20120116131137.GB5265@m.brq.redhat.com>
 <20120117092838.GB10397@elte.hu>
 <20120117102231.GB15447@linux.vnet.ibm.com>
 <20120117105916.GA3664@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120117105916.GA3664@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011711-7408-0000-0000-000001EFAD3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2012-01-17 11:59:16]:

> 
> btw., i'd write the CONFIG_UPROBE_EVENT .config help text:
> 
>  This allows the user to add tracing events on top of userspace
>  dynamic events (similar to tracepoints) on the fly via the
>  traceevents interface. Those events can be inserted wherever 
>  uprobes can probe, and record various registers.
> 
>  This option is required if you plan to use perf-probe 
>  subcommand of perf tools on user space applications.
> 
> In a clearer form:
> 
>  This allows the user to add user-space dynamic events on the 
>  fly, similar to tracepoints. These events can be inserted
>  into just about any user-space code transparently, and can 
>  record register state there on the fly, which is then used by
>  instrumentation tools.
> 
>  This option is required if you plan to use the "perf probe"
>  subcommand of the perf tool on user space applications.
> 

Okay, Will change as suggested.

-- 
Thanks and Regards
Srikar

