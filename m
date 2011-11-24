Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab1KXNNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 08:13:48 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52770 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab1KXNNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 08:13:47 -0500
Date: Thu, 24 Nov 2011 18:42:25 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH v7 3.2-rc2 20/30] tracing: Extract out common code for
 kprobes/uprobes traceevents.
Message-ID: <20111124131225.GE28065@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
 <20111118111039.10512.78989.sendpatchset@srdronam.in.ibm.com>
 <1322076721.20742.66.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1322076721.20742.66.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112413-5930-0000-0000-0000026858C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > + *
> > + * Copyright (C) IBM Corporation, 2010
> > + * Author:     Srikar Dronamraju
> > + *
> > + * Derived from kernel/trace/trace_kprobe.c written by
> 
> Shouldn't the above be:
> 
>  include/linux/trace_kprobe.h ?
> 
> Although, I would think both of these files are a bit more that derived
> from. I would have been a bit stronger on the wording and say: This code
> was copied from trace_kprobe.[ch] written by Masami ...
> 
> Then say,
> 
> Updates to make this generic:
> 
>  * Copyright (C) IBM Corporation, 2010
>  * Author:     Srikar Dronamraju
> 
> -- Steve
> 

Okay, Will do as suggested.
Thanks for reporting/suggesting.

-- 
Thanks and Regards
Srikar

