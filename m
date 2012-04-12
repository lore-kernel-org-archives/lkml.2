Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934365Ab2DLPS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 11:18:58 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46469 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab2DLPS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:18:57 -0400
Date: Thu, 12 Apr 2012 20:40:37 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: Re: Re: [PATCH] perf/probe: Provide perf interface for uprobes
Message-ID: <20120412151037.GC21587@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120411135742.29198.45061.sendpatchset@srdronam.in.ibm.com>
 <20120411144918.GD16257@infradead.org>
 <20120411170343.GB29831@linux.vnet.ibm.com>
 <20120411181727.GK16257@infradead.org>
 <4F864BB3.3090405@hitachi.com>
 <20120412140751.GM16257@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120412140751.GM16257@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041215-7182-0000-0000-0000013F826F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  $ perf probe libc malloc
> 
> 	Makes it even easier to use.
> 
> 	Its just when one asks for something that has ambiguities that
> the tool should ask the user to be a bit more precise to remove such
> ambiguity.
> 
> 	After all...
> 

Another case 
perf probe do_fork clone_flags now looks for variable clone_flags in
kernel function do_fork.

But if we allow to trace perf probe zsh zfree; then 
'perf probe do_fork clone_flags' should it check for do_fork executable
or not? If it does check and finds one, and searches for clone_flags
function and doesnt find, then should it continue with searching the
kernel?

-- 
Thanks and Regards
Srikar

